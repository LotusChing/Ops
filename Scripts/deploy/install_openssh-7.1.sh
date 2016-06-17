#!/bin/bash -e

green="\033[32m"
red="\033[31m"
over="\033[0m"
base=`pwd`
null="/dev/null"

temp_dir="/tmp/openssh-install"
pam_sshd="/etc/pam.d/sshd"
sshd_config="/etc/ssh/sshd_config"
openssh65="openssh-7.1p1-el65.tar.gz"
openssh67="openssh-7.1p1-el67.tar.gz"

[ ! -d $temp_dir ] && mkdir -p $temp_dir

backup(){
    cp -f ${pam_sshd}{,.default}
    cp -f ${sshd_config}{,.default}
}


download(){
    echo "###### Download ######"
    wget deploy.felicity.family/tarball/${openssh67} -P ${temp_dir}/ &> $null
    [ $? -eq 0 ]  && echo -e "Download OpenSSH \t ${green}[OK]${over}" || echo -e "Download OpenSSH \t ${red}[Failed]${over}"   
    cd ${temp_dir} && tar xf ${openssh67} &> ${null}
}

uninstall(){
    echo "###### Remove Old OpenSSH ######"
    rpm -e systemtap-client systemtap git perl-Git 
    rpm -e `rpm -qa|grep openssh`
    [ $? -eq 0 ]  && echo -e "Remove OpenSSH \t ${green}[OK]${over}" || echo -e "Remove OpenSSH \t ${red}[Failed]${over}"
}

install(){
    echo "###### Install New OpenSSH ######"
    rpm -Uvh *.rpm &> ${null}
    [ $? -eq 0 ]  && echo -e "Install OpenSSH \t ${green}[OK]${over}" || echo -e "Install OpenSSH \t ${red}[Failed]${over}"
    rm -f ${pam_sshd} ${sshd_config}
    cp -f ${pam_sshd}.default    ${pam_sshd}
    cp -f ${sshd_config}.default ${sshd_config}
    sed -r -i 's/#PermitRootLogin\ yes/PermitRootLogin\ yes/g' ${sshd_config}
}

startup(){
    echo "###### Startup ######"
    userdel sshd && useradd -u 555 -M -s /sbin/nologin sshd
    /etc/init.d/sshd stop &> ${null}
    netstat -tunlp|grep ssh || /etc/init.d/sshd start &> ${null}
    [ $? -eq 0 ]  && echo -e "Start OpenSSH \t ${green}[OK]${over}" || echo -e "Start OpenSSH \t ${red}[Failed]${over}"
}

clean(){
    echo "###### Clean ######"
    rm -rf ${temp_dir}
    rm -f ${base}/install_openssh-7.1.sh
    echo "Clean some temp file"
}

go(){
    backup
    download
    uninstall
    install
    startup
    clean   
}

$1
