#!/bin/bash
temp_dir="/tmp/install-dropbear"
pkgs_name="dropbear-compiled.tar.gz"

download(){
   wget forever.felicity.family/tarball/${pkgs_name} -P ${temp_dir}/
}

dropbear(){
    cd ${temp}
    tar xf ${pkgs_name} -C /usr/local/
    cp dropbear /etc/init.d/
    chmod +x /etc/init.d/dropbear
    chkconfig --add dropbear
    /etc/init.d/dropbear start
}

go(){
    dropbear
}
$1
