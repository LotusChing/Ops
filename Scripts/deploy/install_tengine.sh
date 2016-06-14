#!/bin/bash
set -e
green="\033[32m"
red="\033[31m"
over="\033[0m"
base=`pwd`
null="/dev/null"
server="deploy.felicity.family"
soft="tengine-2.1.2.tar.gz"
temp_dir="/tmp/tengine_install"

[ ! -d $temp_dir ] && mkdir -p $temp_dir

download(){
    echo '###### Download ######'
    wget $server/tarball/$soft -P $temp_dir
    [ $? -eq 0 ] && echo -e "Download tengine \t ${green}[OK]${over}"  || echo -e "Download $soft \t ${red}[Failed]${over}"
}

require(){
    yum -y install openssl-devel zlibc-devel pcre-devel &> $null
    [ $? -eq 0 ] && echo -e "Install $soft require \t ${green}[OK]${over}" || echo -e "Download $soft \t ${red}[Failed]${over}"
}

install(){
    echo '###### Install ######'
    cd $temp_dir && tar xf $soft -C /opt &> $null
    useradd -M -s /sbin/nologin nginx
    [ $? -eq 0 ] && echo -e "Install $soft \t ${green}[OK]${over}"  || echo -e "Install $soft \t ${red}[Failed]${over}"
}

config(){
    echo '###### Config ######'
    
    [ $? -eq 0 ] && echo -e "Config $soft \t ${green}[OK]${over}"   || echo -e "Config $soft \t ${red}[Failed]${over}"
}

startup(){
    echo '###### startup ######'

    [ $? -eq 0 ] && echo -e "Startup $soft \t ${green}[OK]${over}"  || echo -e "Startup $soft \t ${red}[Failed]${over}"
}

clean(){
    echo '###### clean ######'
    /opt/tengine/sbin/nginx
    [ $? -eq 0 ] && echo -e "Clean $soft \t ${green}[OK]${over}"    || echo -e "Clean $soft \t ${red}[Failed]${over}"
}

readme(){
    echo '###### Generate readme ######'
    Soft: Tengine-2.1.2
    Path: /opt/tengine
    Port: 80
    [ $? -eq 0 ] && echo -e "Generate readme $soft \t ${green}[OK]${over}" || echo -e "Generate readme $soft \t ${red}[Failed]${over}"
}

go(){
  download
  require
  install
  config
  startup
  clean
  readme
}

$1
