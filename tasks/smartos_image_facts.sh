#!/usr/bin/env bash

if ! which ansible &> /dev/null; then
  echo '{"_error": {"msg": "Ansible must be installed and on PATH to run ansible modules", "kind": "ansible/not-installed", "details": {}}}'
  exit 1
fi

params=''
if [ ! -z "${PT_filters+x}" ];
  then params="${params} filters=\"${PT_filters}\""
fi

ansible localhost -m smartos_image_facts --args "${params}" --one-line | cut -f2- -d">"