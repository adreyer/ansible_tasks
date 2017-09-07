#!/usr/bin/env bash

if ! which ansible &> /dev/null; then
  echo '{"_error": {"msg": "Ansible must be installed and on PATH to run ansible modules", "kind": "ansible/not-installed", "details": {}}}'
  exit 1
fi

params=''
if [ ! -z "${PT_username+x}" ];
  then params="${params} username=\"${PT_username}\""
fi

if [ ! -z "${PT_protocol+x}" ];
  then params="${params} protocol=\"${PT_protocol}\""
fi

if [ ! -z "${PT_timeout+x}" ];
  then params="${params} timeout=\"${PT_timeout}\""
fi

if [ ! -z "${PT_verify_ssl+x}" ];
  then params="${params} verify_ssl=\"${PT_verify_ssl}\""
fi

if [ ! -z "${PT_wait_timeout+x}" ];
  then params="${params} wait_timeout=\"${PT_wait_timeout}\""
fi

if [ ! -z "${PT_credentials+x}" ];
  then params="${params} credentials=\"${PT_credentials}\""
fi

if [ ! -z "${PT_port+x}" ];
  then params="${params} port=\"${PT_port}\""
fi

if [ ! -z "${PT_vip_id+x}" ];
  then params="${params} vip_id=\"${PT_vip_id}\""
fi

if [ ! -z "${PT_name+x}" ];
  then params="${params} name=\"${PT_name}\""
fi

if [ ! -z "${PT_algorithm+x}" ];
  then params="${params} algorithm=\"${PT_algorithm}\""
fi

if [ ! -z "${PT_region+x}" ];
  then params="${params} region=\"${PT_region}\""
fi

if [ ! -z "${PT_wait+x}" ];
  then params="${params} wait=\"${PT_wait}\""
fi

if [ ! -z "${PT_state+x}" ];
  then params="${params} state=\"${PT_state}\""
fi

if [ ! -z "${PT_meta+x}" ];
  then params="${params} meta=\"${PT_meta}\""
fi

if [ ! -z "${PT_env+x}" ];
  then params="${params} env=\"${PT_env}\""
fi

if [ ! -z "${PT_api_key+x}" ];
  then params="${params} api_key=\"${PT_api_key}\""
fi

if [ ! -z "${PT_type+x}" ];
  then params="${params} type=\"${PT_type}\""
fi

ansible localhost -m rax_clb --args "${params}" --one-line | cut -f2- -d">"