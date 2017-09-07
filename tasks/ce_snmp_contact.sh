#!/usr/bin/env bash

if ! which ansible &> /dev/null; then
  echo '{"_error": {"msg": "Ansible must be installed and on PATH to run ansible modules", "kind": "ansible/not-installed", "details": {}}}'
  exit 1
fi

params=''
if [ ! -z "${PT_state+x}" ];
  then params="${params} state=\"${PT_state}\""
fi

if [ ! -z "${PT_contact+x}" ];
  then params="${params} contact=\"${PT_contact}\""
fi

ansible localhost -m ce_snmp_contact --args "${params}" --one-line | cut -f2- -d">"