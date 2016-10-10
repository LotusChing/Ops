#!/bin/bash
green="\033[32m"
red="\033[31m"
over="\033[0m"
base=`pwd`
null="/dev/null"
ftp_conf="/etc/vsftpd/vsftpd.conf"

Require(){
    echo "###### Process Required ######"
    yum -y install vsftpd &> $null
    [ $? -eq 0 ] && echo -e "Process Required \t ${green}[OK]${over}"  || echo -e "Process Required \t ${red}[Failed]${over}"
}

Config(){
    echo "###### Config vsftpd ######"
    sed -r -i '27c anon_upload_enable=YES'      $ftp_conf
    sed -r -i '31c anon_mkdir_write_enable=YES' $ftp_conf
    [ $? -eq 0 ] && echo -e "Config vsftpd \t ${green}[OK]${over}"     || echo -e "Config vsftpd \t ${red}[Failed]${over}"
}

Restart(){
    echo "###### Restart Service ######"
    /etc/init.d/vsftpd start &> $null
    [ $? -eq 0 ] && echo -e "Restart Service \t ${green}[OK]${over}"   || echo -e "Restart Service \t ${red}[Failed]${over}"
}

go(){
  Require
  Config
  Restart
}

$1
