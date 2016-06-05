#!/bin/bash -e
green="\033[32m"
red="\033[31m"
over="\033[0m"
base=`pwd`
null="/dev/null"
temp_dir="/tmp/redis-install"
package="redis-3.0.5.tar.gz"

inital(){
    echo '###### Inital ######'
    [ ! -d $temp_dir ] && mkdir -p $temp_dir
    yum -y install gcc &> $null
    [ $? -eq 0 ]  && echo -e "Inital \t ${green}[OK]${over}"         || echo -e "Inital \t ${red}[Failed]${over}"
}

download(){
    echo '###### Download ######'
    wget forever.felicity.family/tarball/$package  &> $null
    [ $? -eq 0 ]  && echo -e "Download Redis \t ${green}[OK]${over}" || echo -e "Download Redis \t ${red}[Failed]${over}" 
}

compile(){
    echo '###### Compile ######'
    cd $temp_dir && tar xf $package && cd redis-3.0.5
    make PREFIX=/usr/local/redis-3.0.5 install &> $null
    [ $? -eq 0 ]  && echo -e "Compile Redis \t ${green}[OK]${over}"  || echo -e "Compile Redis \t ${red}[Failed]${over}"
}

install(){
    echo '###### Install ######'
    cp utils/redis_init_script /etc/init.d/redis
    ln -s /usr/local/redis-3.0.5 /usr/local/redis
    mkdir /etc/redis && cp redis.conf /etc/redis/6379.conf
    [ $? -eq 0 ]  && echo -e "Install Redis \t ${green}[OK]${over}"  || echo -e "Install Redis \t ${red}[Failed]${over}"
}

config(){
    echo '###### Configure ######'
    echo "export PATH=$PATH:/usr/local/redis/bin:/usr/local/redis/sbin" >>/etc/profile
    source /etc/profile
    sed -r -i '7c EXEC=/usr/local/redis/bin/redis-server' /etc/init.d/redis   
    sed -r -i '8c CLIEXEC=/usr/local/redis/bin/redis-cli' /etc/init.d/redis   
    [ $? -eq 0 ]  && echo -e "Config Redis \t ${green}[OK]${over}"  || echo -e "Config Redis \t ${red}[Failed]${over}"
}

startup(){
    echo '###### Startup ######'
    /etc/init.d/redis start   
}

clean(){
    echo '###### Clean ######'
    rm -rf $temp_dir
    [ $? -eq 0 ]  && echo -e "Clean temp file \t ${green}[OK]${over}"  || echo -e "Clean temp file \t ${red}[Failed]${over}"
}

readme(){
    echo '''
    Redis Binary: /usr/local/redis/
    Redis Config: /etc/redis
    Reids Port:   6379
    '''
}

go

$1
