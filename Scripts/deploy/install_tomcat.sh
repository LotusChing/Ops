#!/bin/bash
set -e
green="\033[32m"
red="\033[31m"
over="\033[0m"
base=`pwd`
null="/dev/null"
server="deploy.felicity.family"
soft="Tomcat"
pkgs="apache-tomcat-7.0.70.tar.gz"
temp_dir="/tmp/$soft"
openjdk="java-1.7.0-openjdk-1.7.0.45-2.4.3.3.el6.x86_64"

require(){
    echo '###### Process Require ######'
    rpm -qa|grep $openjdk &> $null || yum -y install $openjdk &> $null
    ls -l /usr/lib/jvm/java-1.7.0-openjdk-1.7.0.45.x86_64/jre/bin/java &> $null
    [ $? -eq 0 ] && echo -e "Process Require \t ${green}[OK]${over}"  || echo -e "Process Require \t ${red}[Failed]${over}"
}

download(){
    echo '###### Download ######'
    wget $server/tarball/$pkgs -P $temp_dir &> $null
    [ $? -eq 0 ] && echo -e "Download $pkgs \t ${green}[OK]${over}"   || echo -e "Download $pkgs \t ${red}[Failed]${over}"
}

install(){
    echo '###### Install ######'
    cd $temp_dir && tar xf $pkgs -C /opt/tomcat-7
    ln -s /opt/tomcat-7 /opt/tomcat
    [ $? -eq 0 ] && echo -e "Install $soft \t ${green}[OK]${over}"    || echo -e "Install $soft \t ${red}[Failed]${over}"
}

config(){
    echo '###### Config ######'
    cat >> /etc/profile << EOF
# Java Tomcat Environment Config
JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-1.7.0.45.x86_64/jre/
PATH=\$PATH:JAVA_HOME/bin:/root/commands
CATALINA_HOME=/opt/tomcat-7
export JAVA_HOME PATH CATALINA_HOME
EOF
    source /etc/profile
    [ $? -eq 0 ] && echo -e "Config $soft \t ${green}[OK]${over}"   || echo -e "Config $soft \t ${red}[Failed]${over}"
}

startup(){
    echo '###### startup ######'
    /opt/tomcat/bin/startup.sh &> $null
    [ $? -eq 0 ] && echo -e "Startup $soft \t ${green}[OK]${over}"  || echo -e "Startup $soft \t ${red}[Failed]${over}"
}

clean(){
    echo '###### clean ######'
    rm -rf $temp_dir
    rm -f $0
    [ $? -eq 0 ] && echo -e "Clean $soft \t ${green}[OK]${over}"    || echo -e "Clean $soft \t ${red}[Failed]${over}"
}

readme(){
    echo '###### SummaryInfo ######'
    echo """
    Soft: tomcat-7
    Path: /opt/tomcat
    JDK:  openjdk-1.7.0
    Port: 8080"""
    [ $? -eq 0 ] && echo -e "Generate readme $soft \t ${green}[OK]${over}" || echo -e "Generate readme $soft \t ${red}[Failed]${over}"
}

go(){
  require
  download
  install
  config
  startup
  clean
  readme
}

$1
