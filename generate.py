#!/usr/bin/env python

# $ make_tasks.py [puppet tasksdir]
# This script will convert the installed ansible modules into native tasks It
# does this by building the ansibleball then modifying it to read input from
# stdin Because the ansiball contains a zip file rerunning this script will
# result in changes to all tasks.  TODO: parse the ansiball instead of doing a
# string replace

import base64
import glob
import json
import os
import re
import sys
import tempfile
import zipfile

from ansible import constants as C
from ansible.executor.module_common import modify_module
from ansible.plugins import module_loader
import ansible.utils.plugin_docs as plugin_docs

def find_modules():
  plugins = set()
  paths = module_loader._get_paths()
  for path in paths:
      if not os.path.exists(path):
          continue
      for plugin in os.listdir(path):
          full_path = '/'.join([path, plugin])
          if plugin.startswith('.'):
              continue
          elif os.path.isdir(full_path):
              continue
          elif any(plugin.endswith(x) for x in C.BLACKLIST_EXTS):
              continue
          elif plugin.startswith('__'):
              continue
          elif plugin in C.IGNORE_FILES:
              continue
          elif plugin .startswith('_'):
              if os.path.islink(full_path):  # avoids aliases
                  continue

          plugin = os.path.splitext(plugin)[0]  # removes the extension
          plugin = plugin.lstrip('_')  # remove underscore from deprecated plugins

          if plugin not in plugin_docs.BLACKLIST.get("MODULE", ()):
              plugins.add(plugin)

  return [module_loader.find_plugin(p, mod_type='.py', ignore_deprecated=True) for p in plugins]


def load_metadata(module_path):
  "Ansible doesn't call this metadata but doc?"
  return plugin_docs.get_docstring(module_path)[0]

def make_param(opt):
  choices = opt.get('choices', False)
  if choices:
    choices = ['"%s"' % c for c in choices]
    typ = 'Enum[%s]' % ', '.join(choices)
  else:
    typ = 'String[0]'

  if (not opt.get('required', False)) or opt.get('default', False):
    typ = 'Optional[%s]' % typ

  desc = opt.get('description', [''])[0]
  return { 'description': desc, 'type': typ }


def make_metadata(doc):
  metadata = {'description': doc.get('description', [''])[0],
              'input_method': 'stdin',
              'parameters': {}}

  for name, opt in doc['options'].iteritems():
    metadata['parameters'][name] = make_param(opt)
  return metadata

def make_py_module(module_name, module_path):
  sigil = "&@SIGIL@&"
  ball = modify_module(module_name, module_path, sigil)[0]
  # Replace the sigil
  find = '\'{"ANSIBLE_MODULE_ARGS": "' + sigil + '"}\''
  replace = 'json.dumps({"ANSIBLE_MODULE_ARGS": json.load(sys.stdin)})'

  # Some modules are just metadata stubs. Don't make the tast if there aren't
  # ANSIBALLZ_PARAMS to set.
  if ball.find(find) == -1:
    sys.stderr.write("failed to build module %s couldn't find ANSIBALLZ_PARAMS.\n" % module_path)
    return
  else:
    ball = ball.replace(find, replace)
  return ball

def make_ps1_module(module_name, module_path):
  "Create a ps1 script whith any helpers inlined."
  ball = modify_module(module_name, module_path, sigil)[0]
  mock = type('', (), {})()
  mock.async = None
  mock.become = None
  win_ball = build_windows_module_payload('win_acl', module_path, ball, '', {}, mock, mock, {})
  script = "# This file should contail all necessary functions\n"
  for name, mod in win_ball['powershell_modules'].iteritems():
    script += '# BEGIN%s\n' % name
    script += base64.decodestring(mod)
    script += '# END%s\n\n' % name
  script += " # BEGIN module content\n"
  script += base64.decodestring(win_ball['module_entry'])

def make_ansible_module(module_name, doc):
  "Some modules are abstractions over real modules implemented in the ansible CLI"

  script = '''#!/usr/bin/env bash
if ! which ansible &> /dev/null; then
  echo '{"_error": {"msg": "Ansible must be installed and on PATH to run ansible modules", "kind": "ansible/not-installed", "details": {}}}'
  exit 1
fi
params=''
'''

  for opt in doc['options']:
    param_str = '''if [ ! -z "${PT_%s+x}" ];
then params="${params} %s=\\"${PT_%s}\\""
fi
'''
    script += param_str % (opt, opt, opt)

  script += 'ansible localhost -m %s --args "${params}" --one-line | cut -f2- -d">"' % module_name
  return script


def make_task(module_path, task_dir):
  "This makes a task that will read arguments from stdin from an ansible module"

  try:
    doc = load_metadata(module_path)
    module_name = doc['module']
    print "making %s task" % module_name
  except:
    sys.stderr.write("failed to build module %s couldn't find it's name\n" % module_path)
    return

  metadatafile = os.path.join(task_dir, '%s.json' % module_name)

  metadata = make_metadata(doc)
  ps1_path = os.path.join(os.path.basename(module_path), 'module_name' + '.ps1')
  print ps1_path
  if os.path.exists(ps1_path):
    taskfile = os.path.join(task_dir, '%s.ps1' % module_name)
    task = make_ps1_module(ps1_path)
  else:
    task = make_py_module(module_name, module_path)
    if task:
      taskfile = os.path.join(task_dir, '%s.py' % module_name)
    else:
      task = make_ansible_module(module_name, doc)
      taskfile = os.path.join(task_dir, module_name + '.sh')
      metadata['description'] += " This task requires ansible to be installed on the target."

  with open(taskfile, 'w') as fh:
    fh.write(task)
  os.chmod(taskfile, 0755)
  with open(metadatafile, 'w') as fh:
    json.dump(metadata, fh, indent=2)


if __name__ == '__main__':

  if len(sys.argv) > 1:
    task_dir = sys.argv[1]
  else:
    task_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), 'tasks'))

  for module_path in find_modules():
   make_task(module_path, task_dir)
