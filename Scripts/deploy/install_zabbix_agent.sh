#!/bin/bash
set -e
green="\033[32m"
red="\033[31m"
over="\033[0m"
base=`pwd`
null="/dev/null"
soft="zabbix-agent"
zabbix_agent_conf="/etc/zabbix_agentd.conf"
zabbix_server=$2
fuck='$1'

install(){
    echo '###### Install ######'
    yum -y install zabbix22 zabbix22-agent.x86_64 &> $null
    [ $? -eq 0 ] && echo -e "Install $soft \t ${green}[OK]${over}"  || echo -e "Install $soft \t ${red}[Failed]${over}"
}

config(){
    echo '###### Config ######'
    cp -f ${zabbix_agent_conf}{,.default}
    curl -s deploy.felicity.family/Ops/Scripts/zabbix/check_system_util_info.sh > /etc/zabbix/check_system_util_info.sh
    echo """
PidFile=/var/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
LogFileSize=0
Server=$zabbix_server
ServerActive=127.0.0.1
Hostname=Zabbix server
Timeout=30
UserParameter=system.util.info[*], bash /etc/zabbix/check_system_util_info.sh $fuck
""" > $zabbix_agent_conf
    [ $? -eq 0 ] && echo -e "Config $soft \t ${green}[OK]${over}"   || echo -e "Config $soft \t ${red}[Failed]${over}"
}

startup(){
    echo '###### startup ######'
    /etc/init.d/zabbix-agentd start &> $null
    [ $? -eq 0 ] && echo -e "Startup $soft \t ${green}[OK]${over}"  || echo -e "Startup $soft \t ${red}[Failed]${over}"
}

clean(){
    echo '###### clean ######'
    rm -f $base/$0
    [ $? -eq 0 ] && echo -e "Clean $soft \t ${green}[OK]${over}"    || echo -e "Clean $soft \t ${red}[Failed]${over}"
}

readme(){
    echo '###### Generate readme ######'
    echo """
    Soft: zabbix22 zabbix22-agent
    Port: 10050
    Path: /etc/zabbix
    Server: $zabbix_server
    """ >/etc/zabbix/readme
    [ $? -eq 0 ] && echo -e "Generate readme $soft \t ${green}[OK]${over}" || echo -e "Generate readme $soft \t ${red}[Failed]${over}"
}

go(){
  install
  config
  startup
  clean
  readme
}

$1
