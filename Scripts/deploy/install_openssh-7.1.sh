#!/bin/bash

temp_dir="/tmp/openssh-install"
pam_sshd="/etc/pam.d/sshd"
sshd_config="/etc/ssh/sshd_config"
openssh65="openssh-7.1p1-el65.tar.gz"
openssh67="openssh-7.1p1-el67.tar.gz"

[ ! -d $temp_dir ] && mkdir -p $temp_dir

dropbear(){
    cd $temp_dir
    wget forever.felicity.family/tarball/dropbear.tar.gz
    tar xf dropbear.tar.gz && bash Dropbear.sh
}

backup(){
    cp -f ${pam_sshd}{,.default}
    cp -f ${sshd_config}{,.default}
}

uninstall(){
    rpm -e systemtap-client systemtap git perl-Git 
    rpm -e `rpm -qa|grep openssh`
}

openssh(){
    wget forever.felicity.family/tarball/${openssh67}
    tar xf ${openssh67}
    rpm -Uvh *.rpm
    rm -f ${pam_sshd} ${sshd_config}
    cp -f ${pam_sshd}.default    ${pam_sshd}
    cp -f ${sshd_config}.default ${sshd_config}
    sed -r -i 's/#PermitRootLogin\ yes/PermitRootLogin\ yes/g' ${sshd_config}
}

clean(){
    rm -rf ${temp_dir}
}

startup(){
    userdel sshd && useradd -u 555 -M -s /sbin/nologin sshd
    netstat -tunlp|grep ssh || /etc/init.d/sshd start
}

go(){
    dropbear
    backup
    uninstall
    openssh
    clean   
    startup
}

$1
