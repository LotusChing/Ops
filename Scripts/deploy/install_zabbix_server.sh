#!/bin/bash -e
green="\033[32m"
red="\033[31m"
over="\033[0m"
base=`pwd`
null="/dev/null"
dbuser="root"
dbpass=`cat /root/.pass`
dbsock="/tmp/mysql.sock"
mysql_cmd="/usr/bin/mysql"
php_conf="/etc/php.ini"

#install packages
pkgs(){
    echo "######Install Packages######"
    yum -y install php php-common mysql mysql-server zabbix22-agent zabbix22-web-mysql zabbix22-server-mysql &> $null
    [ $? -eq 0 ]  && echo -e "Install Packages \t ${green}[OK]${over}"  ||  echo -e "Install Packages \t ${red}[Failed]${over}"
}

#inital php
php(){
    echo "######Configure PHP######"
    sed -r -i '729c post_max_size = 16M'             ${php_conf} && \
    sed -r -i '449c max_input_time = 300'            ${php_conf} && \
    sed -r -i '440c max_execution_time = 300'        ${php_conf} && \
    sed -r -i '946c date.timezone = Asia\/Shanghai'  ${php_conf}
    [ $? -eq 0 ]  && echo -e "Config PHP \t ${green}[OK]${over}"  ||  echo -e "Config PHP \t ${red}[Failed]${over}"
}

#inital mysql
mysql(){
    echo "######Configure MySQL######"
    ${mysql_cmd} -u${dbuser} -p${dbpass} -e "create database zabbix character set utf8;" && \
    ${mysql_cmd} -u${dbuser} -p${dbpass} -e "grant all on zabbix.* to 'monit0r'@'localhost' identified by 'monit0r';" && \
    ${mysql_cmd} -u${dbuser} -p${dbpass} -e "flush privileges;" && \
    ${mysql_cmd} -u${dbuser} -p${dbpass} zabbix < /usr/share/zabbix-mysql/schema.sql && \
    ${mysql_cmd} -u${dbuser} -p${dbpass} zabbix < /usr/share/zabbix-mysql/images.sql && \
    ${mysql_cmd} -u${dbuser} -p${dbpass} zabbix < /usr/share/zabbix-mysql/data.sql
    [ $? -eq 0 ]  && echo -e "Import Data to MySQL \t ${green}[OK]${over}"         || echo -e "Import Data to MySQL \t ${red}[Failed]${over}"
}

#install zabbix
zabbix(){
    echo "######Configure Zabbix######"
    cp /etc/zabbix/zabbix_server.conf{,.default}
    cat > /etc/zabbix/zabbix_server.conf << EOF
ListenPort=10051
LogFile=/var/log/zabbixsrv/zabbix_server.log
PidFile=/var/run/zabbixsrv/zabbix_server.pid
DBHost=127.0.0.1
DBName=zabbix
DBUser=${dbuser}
DBPassword=${dbpass}
DBSocket=${dbsock}
DBPort=3306
ListenIP=127.0.0.1
AlertScriptsPath=/var/lib/zabbixsrv/alertscripts
ExternalScripts=/var/lib/zabbixsrv/externalscripts
TmpDir=/var/lib/zabbixsrv/tmp
EOF
    [ $? -eq 0 ]  && echo -e "Config Zabbix Server \t ${green}[OK]${over}"         || echo -e "Config Zabbix Server \t ${red}[Failed]${over}"
}

startup(){
    echo "###### Startup Service ######"
    lsof -i :3306  &> ${null} || service mysqld start
    lsof -i :10051 &> ${null} || service zabbix-server start
    lsof -i :80    &> ${null} || service httpd  start
}

readme(){
  echo """
  soft: php php-common mysql mysql-server zabbix22-agent zabbix22-web-mysql zabbix22-server-mysql
  port: 80 3306 10051
  path: /etc/zabbix/  /var/log/zabbixsrv/
  """ > /etc/zabbix/readme.txt
}

go(){
    pkgs
    php
    mysql
    zabbix
    startup
}
$1
