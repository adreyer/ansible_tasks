#!/usr/bin/env bash

if ! which ansible &> /dev/null; then
  echo '{"_error": {"msg": "Ansible must be installed and on PATH to run ansible modules", "kind": "ansible/not-installed", "details": {}}}'
  exit 1
fi

params=''
if [ ! -z "${PT_datacenter+x}" ];
  then params="${params} datacenter=\"${PT_datacenter}\""
fi

if [ ! -z "${PT_subscription_user+x}" ];
  then params="${params} subscription_user=\"${PT_subscription_user}\""
fi

if [ ! -z "${PT_server+x}" ];
  then params="${params} server=\"${PT_server}\""
fi

if [ ! -z "${PT_volume+x}" ];
  then params="${params} volume=\"${PT_volume}\""
fi

if [ ! -z "${PT_state+x}" ];
  then params="${params} state=\"${PT_state}\""
fi

if [ ! -z "${PT_wait_timeout+x}" ];
  then params="${params} wait_timeout=\"${PT_wait_timeout}\""
fi

if [ ! -z "${PT_subscription_password+x}" ];
  then params="${params} subscription_password=\"${PT_subscription_password}\""
fi

if [ ! -z "${PT_wait+x}" ];
  then params="${params} wait=\"${PT_wait}\""
fi

ansible localhost -m profitbricks_volume_attachments --args "${params}" --one-line | cut -f2- -d">"