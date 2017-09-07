#!/usr/bin/env bash

if ! which ansible &> /dev/null; then
  echo '{"_error": {"msg": "Ansible must be installed and on PATH to run ansible modules", "kind": "ansible/not-installed", "details": {}}}'
  exit 1
fi

params=''
if [ ! -z "${PT_username+x}" ];
  then params="${params} username=\"${PT_username}\""
fi

if [ ! -z "${PT_marathon_app_name+x}" ];
  then params="${params} marathon_app_name=\"${PT_marathon_app_name}\""
fi

if [ ! -z "${PT_description+x}" ];
  then params="${params} description=\"${PT_description}\""
fi

if [ ! -z "${PT_marathon_service_port+x}" ];
  then params="${params} marathon_service_port=\"${PT_marathon_service_port}\""
fi

if [ ! -z "${PT_ranges+x}" ];
  then params="${params} ranges=\"${PT_ranges}\""
fi

if [ ! -z "${PT_controller+x}" ];
  then params="${params} controller=\"${PT_controller}\""
fi

if [ ! -z "${PT_addrs+x}" ];
  then params="${params} addrs=\"${PT_addrs}\""
fi

if [ ! -z "${PT_password+x}" ];
  then params="${params} password=\"${PT_password}\""
fi

if [ ! -z "${PT_tenant+x}" ];
  then params="${params} tenant=\"${PT_tenant}\""
fi

if [ ! -z "${PT_name+x}" ];
  then params="${params} name=\"${PT_name}\""
fi

if [ ! -z "${PT_country_codes+x}" ];
  then params="${params} country_codes=\"${PT_country_codes}\""
fi

if [ ! -z "${PT_uuid+x}" ];
  then params="${params} uuid=\"${PT_uuid}\""
fi

if [ ! -z "${PT_url+x}" ];
  then params="${params} url=\"${PT_url}\""
fi

if [ ! -z "${PT_tenant_ref+x}" ];
  then params="${params} tenant_ref=\"${PT_tenant_ref}\""
fi

if [ ! -z "${PT_apic_epg_name+x}" ];
  then params="${params} apic_epg_name=\"${PT_apic_epg_name}\""
fi

if [ ! -z "${PT_prefixes+x}" ];
  then params="${params} prefixes=\"${PT_prefixes}\""
fi

if [ ! -z "${PT_state+x}" ];
  then params="${params} state=\"${PT_state}\""
fi

if [ ! -z "${PT_ip_ports+x}" ];
  then params="${params} ip_ports=\"${PT_ip_ports}\""
fi

if [ ! -z "${PT_tenant_uuid+x}" ];
  then params="${params} tenant_uuid=\"${PT_tenant_uuid}\""
fi

if [ ! -z "${PT_api_version+x}" ];
  then params="${params} api_version=\"${PT_api_version}\""
fi

ansible localhost -m avi_ipaddrgroup --args "${params}" --one-line | cut -f2- -d">"