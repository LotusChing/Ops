#!/bin/bash 
set -e
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

pkgs(){
    echo "######Install Packages######"
    yum -y install php php-common mysql mysql-server zabbix22-agent zabbix22-web-mysql zabbix22-server-mysql &> $null
    [ $? -eq 0 ]  && echo -e "Install Zabbix Server \t ${green}[OK]${over}" || echo -e "Install Zabbix Server\t ${red}[Failed]${over}"

}

php(){
    echo "######Configure PHP######"
    sed -r -i '729c post_max_size = 16M'             ${php_conf}
    sed -r -i '449c max_input_time = 300'            ${php_conf}
    sed -r -i '440c max_execution_time = 300'        ${php_conf}
    sed -r -i '946c date.timezone = Asia\/Shanghai'  ${php_conf}
    [ $? -eq 0 ]  && echo -e "Configure PHP \t ${green}[OK]${over}" || echo -e "Configure PHP \t ${red}[Failed]${over}"
}

mysql(){
    echo "######Configure MySQL######"
    ${mysql_cmd} -u${dbuser} -p${dbpass} -e "create database zabbix character set utf8;" && \
    ${mysql_cmd} -u${dbuser} -p${dbpass} -e "grant all on zabbix.* to 'monit0r'@'localhost' identified by 'monit0r';" && \
    ${mysql_cmd} -u${dbuser} -p${dbpass} -e "flush privileges;" && \
    ${mysql_cmd} -u${dbuser} -p${dbpass} zabbix < /usr/share/zabbix-mysql/schema.sql && \
    ${mysql_cmd} -u${dbuser} -p${dbpass} zabbix < /usr/share/zabbix-mysql/images.sql && \
    ${mysql_cmd} -u${dbuser} -p${dbpass} zabbix < /usr/share/zabbix-mysql/data.sql   && 
    [ $? -eq 0 ]  && echo -e "Configure MySQL \t ${green}[OK]${over}" || echo -e "Configure MySQL \t ${red}[Failed]${over}"
    
}

zabbix(){    
    ${mysql_cmd} -u${dbuser} -p${dbpass} zabbix < /usr/share/zabbix-mysql/data.sql
    [ $? -eq 0 ]  && echo -e "Inital \t ${green}[OK]${over}"         || echo -e "Inital \t ${red}[Failed]${over}"
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
Timeout=30
AlertScriptsPath=/var/lib/zabbixsrv/alertscripts
ExternalScripts=/var/lib/zabbixsrv/externalscripts
TmpDir=/var/lib/zabbixsrv/tmp
EOF
    [ $? -eq 0 ]  && echo -e "Configure Zabbix Server \t ${green}[OK]${over}" || echo -e "Configure Zabbix Server \t ${red}[Failed]${over}"
}


startup(){
    lsof -i :80    &> ${null} || service httpd  start         && echo "start httpd  ok"
    lsof -i :3306  &> ${null} || service mysqld start         && echo "start mysqld ok"
    lsof -i :10051 &> ${null} || service zabbix-server start  && echo "start zabbix ok"
}

readme(){
  echo """
  soft: php php-common mysql mysql-server zabbix22-agent zabbix22-web-mysql zabbix22-server-mysql
  port: 80 3306 10051
  path: /etc/zabbix/  /var/log/zabbixsrv/
""" > /etc/zabbix/readme.txt
}

clean(){
    rm -f $base/$0
}

go(){
    pkgs
    php
    mysql
    zabbix
    readme
    startup
    clean
}
$1
