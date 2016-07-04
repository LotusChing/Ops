#!/bin/bash
set -e
green="\033[32m"
red="\033[31m"
over="\033[0m"
base=`pwd`
null="/dev/null"
server="deploy.felicity.family"
soft=""
pkgs=""
temp_dir="/tmp/$soft"



[ ! -d $temp_dir ] && mkdir -p $temp_dir
download(){
    echo '###### Download ######'

    [ $? -eq 0 ] && echo -e "Download $soft \t ${green}[OK]${over}"  || echo -e "Download $soft \t ${red}[Failed]${over}"
}

compile(){
    echo '###### Compile ######'

    [ $? -eq 0 ] && echo -e "Compile $soft \t ${green}[OK]${over}"  || echo -e "Compile $soft \t ${red}[Failed]${over}"
}

install(){
    echo '###### Install ######'

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

    [ $? -eq 0 ] && echo -e "Clean $soft \t ${green}[OK]${over}"    || echo -e "Clean $soft \t ${red}[Failed]${over}"
}

readme(){
    echo '###### Summary Info ######'
    echo """
    Content
    Port: 8080"""
    [ $? -eq 0 ] && echo -e "Generate readme $soft \t ${green}[OK]${over}" || echo -e "Generate readme $soft \t ${red}[Failed]${over}"
}

go(){
  download
  compile
  install
  config
  startup
  clean
  readme
}

$1
