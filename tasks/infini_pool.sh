#!/usr/bin/env bash

if ! which ansible &> /dev/null; then
  echo '{"_error": {"msg": "Ansible must be installed and on PATH to run ansible modules", "kind": "ansible/not-installed", "details": {}}}'
  exit 1
fi

params=''
if [ ! -z "${PT_ssd_cache+x}" ];
  then params="${params} ssd_cache=\"${PT_ssd_cache}\""
fi

if [ ! -z "${PT_name+x}" ];
  then params="${params} name=\"${PT_name}\""
fi

if [ ! -z "${PT_system+x}" ];
  then params="${params} system=\"${PT_system}\""
fi

if [ ! -z "${PT_state+x}" ];
  then params="${params} state=\"${PT_state}\""
fi

if [ ! -z "${PT_user+x}" ];
  then params="${params} user=\"${PT_user}\""
fi

if [ ! -z "${PT_password+x}" ];
  then params="${params} password=\"${PT_password}\""
fi

if [ ! -z "${PT_vsize+x}" ];
  then params="${params} vsize=\"${PT_vsize}\""
fi

if [ ! -z "${PT_size+x}" ];
  then params="${params} size=\"${PT_size}\""
fi

ansible localhost -m infini_pool --args "${params}" --one-line | cut -f2- -d">"