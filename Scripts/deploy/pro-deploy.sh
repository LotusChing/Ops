#!/bin/bash

# Init

# Date/Time
CTIME=`date +%F-%H:%M`

# Git Path
GIT_DIR="/root"

# Directory
TAR_DIR="/var/deploy/tar"
DATA_DIR="/var/deploy/tmp"

# Function

init(){
    git clone http://git.shoubo.cn:18070/cong.liu/test-deploy.git
    setenforce 0
    iptables -F
    # yum -y install httpd
    mkdir -p /var/deploy/{tar,tmp}
    echo "Init OK..."
}

git_pro() {
    cd $GIT_DIR/test-deploy  
    API_VERL=`git show|grep commit|cut -d " " -f2`
    API_VER=`echo ${API_VERL:0:8}`
    VERSION="$API_VER"-"$CTIME"
    cp -rf "$GIT_DIR/test-deploy" $DATA_DIR/$VERSION
    echo "Git pull OK..."
}

config_pro() {
    rm -rf /var/www/html && ln -s $DATA_DIR/$VERSION/code /var/www/html 
    rm -rf /etc/httpd/conf && ln -s $DATA_DIR/$VERSION/config /etc/httpd/conf
    service httpd start
    echo "Config OK..."
}

tar_pro() {
    tar cvzf $TAR_DIR/$VERSION.tar.gz $DATA_DIR/$VERSION && echo "Tar OK..."
}

test_pro() {
    elinks -dump 192.168.0.115
}

rollback_list() {
    ls -l $DATA_DIR|grep '^d'|awk -F" " '{print $NF}'
}

rollback_pro() {
    rm -f /var/www/html && rm -f /etc/httpd/conf
    ln -s $DATA_DIR/$1/code /var/www/html
    ln -s $DATA_DIR/$1/config /etc/httpd/conf
}

usage() {
    echo $"Usage: $0 [deloy | rollback-list | rollback-pro {version}]"
}

main() {
    case $1 in 
        init)
            init;
            ;;

	deploy)
            git_pro;
            config_pro;
            tar_pro;
            test_pro;
	    ;;

        rollback-list)
            rollback_list;
            ;;

        rollback-pro)
            rollback_pro $2;
            test_pro;
            ;;
	*)
	    usage;
	    ;;
    esac
}

main $1 $2
