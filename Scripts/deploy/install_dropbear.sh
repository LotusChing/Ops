#!/bin/bash -e

green="\033[32m"
red="\033[31m"
over="\033[0m"

base=`pwd`
null="/dev/null"
temp_dir="/tmp/install-dropbear"
pkgs_name="dropbear-compiled.tar.gz"
domain_name="forever.felicity.family"
conf_dir="${domain_name}/Ops/Configure-File"
script_dir="${domain_name}/Ops/Scripts"

[ ! -d ${temp_dir} ] && mkdir -p $temp_dir

download(){
    echo "###### Download ######"
    wget ${domain_name}/tarball/${pkgs_name} -P ${temp_dir}/ &> ${null}
    [ $? -eq 0 ]  && echo -e "Download Dropbear \t ${green}[OK]${over}" || echo -e "Download Dropbear \t ${red}[Failed]${over}" 
}

dropbear(){
    echo "###### Configure ######"
    cd ${temp_dir}
    tar xf ${pkgs_name} -C /usr/local/ &> ${null}
    wget ${conf_dir}/dropbear -P /etc/init.d/ &> ${null}
    chmod +x /etc/init.d/dropbear
    chkconfig --add dropbear
    /etc/init.d/dropbear start &> ${null}
    [ $? -eq 0 ]  && echo -e "Configure Start Dropbear \t ${green}[OK]${over}" || echo -e "Configure Start Dropbear \t ${red}[Failed]${over}"
}

clean(){
    rm -rf $temp_dir
    rm $base/install_dropbear.sh
}

go(){
    download
    dropbear
    clean
}

$1
