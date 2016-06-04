#!/bin/bash -e
green="\033[32m"
red="\033[31m"
over="\033[0m"
base=`pwd`
null="/dev/null"
temp_dir="/tmp/redis-install"
sshd_config="/etc/ssh/sshd_config"
redis_package="redis-3.0.5.tar.gz"

inital(){
    [ ! -d $temp_dir ] && mkdir -p $temp_dir
    yum -y install gcc &> $null
    [ $? -eq 0 ]  && echo -e "Inital \t ${green}[OK]${over}"         || echo -e "Inital \t ${red}[Failed]${over}"
}

download(){
    wget forever.felicity.family/tarball/$redis_package  &> $null
    [ $? -eq 0 ]  && echo -e "Download Redis \t ${green}[OK]${over}" || echo -e "Download Redis \t ${red}[Failed]${over}" 
}

compile(){
    cd $temp_dir && tar xf $redis_package && cd redis-3.0.5
    make PREFIX=/usr/local/redis-3.0.5 install &> $null
    [ $? -eq 0 ]  && echo -e "Compile Redis \t ${green}[OK]${over}"  || echo -e "Compile Redis \t ${red}[Failed]${over}"
}

install(){
    cp utils/redis_init_script /etc/init.d/redis
    ln -s /usr/local/redis-3.0.5 /usr/local/redis
    mkdir /etc/redis && cp redis.conf /etc/redis/6379.conf
}

config(){
    sed -r -i '7c EXEC=/usr/local/redis/bin/redis-server' /etc/init.d/redis   
    sed -r -i '8c CLIEXEC=/usr/local/redis/bin/redis-cli' /etc/init.d/redis   
}

startup(){
    
}

clean(){

}

readme(){

}

go

$1
