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
    [ $? -eq 0 ] && echo -e "Download $soft \t ${green}[OK]${over}"  || echo -e "Download $soft \t ${red}[Failed]${over}"
}

require(){
    yum -y install openssl-devel zlibc-devel pcre-devel &> $null
    [ $? -eq 0 ] && echo -e "Install $soft require \t ${green}[OK]${over}" || echo -e "Download $soft \t ${red}[Failed]${over}"
}

compile(){
    echo '###### Compile ######'
    cd $temp_dir && tar xf $soft && cd tengine-2.1.2
    ./configure --prefix=/opt/tengine  \
                --with-http_ssl_module \
                --with-http_flv_module \
                --with-http_stub_status_module    \
                --with-http_gzip_static_module    \
                --with-http_upstream_check_module \
                --with-http_realip_module         \
                --with-pcre &> $null
    [ $? -eq 0 ] && echo -e "Compile $soft \t ${green}[OK]${over}"  || echo -e "Compile $soft \t ${red}[Failed]${over}"
}

install(){
    echo '###### Install ######'
    make &> $null && make install $> $null
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
    echo '###### Generate readme ######'

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
