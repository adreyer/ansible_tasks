#!/usr/bin/env bash

if ! which ansible &> /dev/null; then
  echo '{"_error": {"msg": "Ansible must be installed and on PATH to run ansible modules", "kind": "ansible/not-installed", "details": {}}}'
  exit 1
fi

params=''
if [ ! -z "${PT_is_featured+x}" ];
  then params="${params} is_featured=\"${PT_is_featured}\""
fi

if [ ! -z "${PT_sshkey_enabled+x}" ];
  then params="${params} sshkey_enabled=\"${PT_sshkey_enabled}\""
fi

if [ ! -z "${PT_api_http_method+x}" ];
  then params="${params} api_http_method=\"${PT_api_http_method}\""
fi

if [ ! -z "${PT_vm+x}" ];
  then params="${params} vm=\"${PT_vm}\""
fi

if [ ! -z "${PT_domain+x}" ];
  then params="${params} domain=\"${PT_domain}\""
fi

if [ ! -z "${PT_is_extractable+x}" ];
  then params="${params} is_extractable=\"${PT_is_extractable}\""
fi

if [ ! -z "${PT_poll_async+x}" ];
  then params="${params} poll_async=\"${PT_poll_async}\""
fi

if [ ! -z "${PT_api_url+x}" ];
  then params="${params} api_url=\"${PT_api_url}\""
fi

if [ ! -z "${PT_zone+x}" ];
  then params="${params} zone=\"${PT_zone}\""
fi

if [ ! -z "${PT_format+x}" ];
  then params="${params} format=\"${PT_format}\""
fi

if [ ! -z "${PT_is_dynamically_scalable+x}" ];
  then params="${params} is_dynamically_scalable=\"${PT_is_dynamically_scalable}\""
fi

if [ ! -z "${PT_state+x}" ];
  then params="${params} state=\"${PT_state}\""
fi

if [ ! -z "${PT_template_filter+x}" ];
  then params="${params} template_filter=\"${PT_template_filter}\""
fi

if [ ! -z "${PT_is_ready+x}" ];
  then params="${params} is_ready=\"${PT_is_ready}\""
fi

if [ ! -z "${PT_details+x}" ];
  then params="${params} details=\"${PT_details}\""
fi

if [ ! -z "${PT_is_routing+x}" ];
  then params="${params} is_routing=\"${PT_is_routing}\""
fi

if [ ! -z "${PT_api_key+x}" ];
  then params="${params} api_key=\"${PT_api_key}\""
fi

if [ ! -z "${PT_bits+x}" ];
  then params="${params} bits=\"${PT_bits}\""
fi

if [ ! -z "${PT_tags+x}" ];
  then params="${params} tags=\"${PT_tags}\""
fi

if [ ! -z "${PT_api_secret+x}" ];
  then params="${params} api_secret=\"${PT_api_secret}\""
fi

if [ ! -z "${PT_api_timeout+x}" ];
  then params="${params} api_timeout=\"${PT_api_timeout}\""
fi

if [ ! -z "${PT_is_public+x}" ];
  then params="${params} is_public=\"${PT_is_public}\""
fi

if [ ! -z "${PT_requires_hvm+x}" ];
  then params="${params} requires_hvm=\"${PT_requires_hvm}\""
fi

if [ ! -z "${PT_password_enabled+x}" ];
  then params="${params} password_enabled=\"${PT_password_enabled}\""
fi

if [ ! -z "${PT_display_text+x}" ];
  then params="${params} display_text=\"${PT_display_text}\""
fi

if [ ! -z "${PT_account+x}" ];
  then params="${params} account=\"${PT_account}\""
fi

if [ ! -z "${PT_template_tag+x}" ];
  then params="${params} template_tag=\"${PT_template_tag}\""
fi

if [ ! -z "${PT_name+x}" ];
  then params="${params} name=\"${PT_name}\""
fi

if [ ! -z "${PT_url+x}" ];
  then params="${params} url=\"${PT_url}\""
fi

if [ ! -z "${PT_checksum+x}" ];
  then params="${params} checksum=\"${PT_checksum}\""
fi

if [ ! -z "${PT_api_region+x}" ];
  then params="${params} api_region=\"${PT_api_region}\""
fi

if [ ! -z "${PT_cross_zones+x}" ];
  then params="${params} cross_zones=\"${PT_cross_zones}\""
fi

if [ ! -z "${PT_project+x}" ];
  then params="${params} project=\"${PT_project}\""
fi

if [ ! -z "${PT_snapshot+x}" ];
  then params="${params} snapshot=\"${PT_snapshot}\""
fi

if [ ! -z "${PT_mode+x}" ];
  then params="${params} mode=\"${PT_mode}\""
fi

if [ ! -z "${PT_hypervisor+x}" ];
  then params="${params} hypervisor=\"${PT_hypervisor}\""
fi

if [ ! -z "${PT_os_type+x}" ];
  then params="${params} os_type=\"${PT_os_type}\""
fi

ansible localhost -m cs_template --args "${params}" --one-line | cut -f2- -d">"