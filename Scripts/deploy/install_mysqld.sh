#!/bin/bash
set -e
green="\033[32m"
red="\033[31m"
over="\033[0m"
base=`pwd`
null="/dev/null"
soft="mysql-5.6.31"
pkgs="mysql-5.6.31.tar.gz"
temp_dir="/tmp/${soft}"
mysql_path="/usr/local/$soft"
dbfile="/data/dbfile"

download(){
    yum -y install wget cmake ncurses-devel openssl-devel tar libgcrypt-devel &> $null
    echo '###### Download ######'
    wget http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.31.tar.gz -P $temp_dir
    [ $? -eq 0 ] && echo -e "Download $soft \t ${green}[OK]${over}"  || echo -e "Download $soft \t ${red}[Failed]${over}"
}

compile(){
    echo '###### Compile ######'
    yum -y groupinstall "development tools" &> $null
    cd $temp_dir && tar xf $pkgs && cd $temp_dir/$soft
    cmake . -DCMAKE_INSTALL_PREFIX=$mysql_path \
    -DMYSQL_DATADIR=$dbfile \
    -DMYSQL_UNIX_ADDR=$dbfile/mysql.sock \
    -DDEFAULT_CHARSET=utf8 \
    -DDEFAULT_COLLATION=utf8_general_ci \
    -DEXTRA_CHARSETS=all \
    -DENABLED_LOCAL_INFILE=ON \
    -DWITH_INNOBASE_STORAGE_ENGINE=1 \
    -DWITH_FEDERATED_STORAGE_ENGINE=1 \
    -DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
    -DWITHOUT_EXAMPLE_STORAGE_ENGINE=1 \
    -DWITH_FAST_MUTEXES=1 \
    -DWITH_ZLIB=bundled \
    -DENABLED_LOCAL_INFILE=1 \
    -DWITH_READLINE=1 \
    -DWITH_EMBEDDED_SERVER=1 \
    -DWITH_DEBUG=0 && make && make install
    [ $? -eq 0 ] && echo -e "Compile $soft \t ${green}[OK]${over}"   || echo -e "Compile $soft \t ${red}[Failed]${over}"
}

install(){
    echo '###### Install ######'
    echo "export PATH=$mysql_path/bin:$PATH" >>/etc/profile && source /etc/profile
    cp support-files/mysql.server /etc/init.d/mysqld
    chmod +x /etc/init.d/mysqld
    ./scripts/mysql_install_db --basedir=/$mysql_path --datadir=$dbfile --user=mysql &> $null
    [ $? -eq 0 ] && echo -e "Install initial mysql $soft \t ${green}[OK]${over}"   || echo -e "Install initial mysql $soft \t ${red}[Failed]${over}"
}

config(){
    echo '###### Config ######'
    wget deploy.felicity.family/Ops/Configure-File/my.cnf -P /etc/
    chown -R mysql:mysql $datadir
    [ $? -eq 0 ] && echo -e "Config $soft \t ${green}[OK]${over}"    || echo -e "Config $soft \t ${red}[Failed]${over}"
}

startup(){
    echo '###### startup ######'
    /etc/init.d/mysqld start
    [ $? -eq 0 ] && echo -e "Startup $soft \t ${green}[OK]${over}"   || echo -e "Startup $soft \t ${red}[Failed]${over}"
}

clean(){
    echo '###### clean ######'
    rm -rf $temp_dir
    [ $? -eq 0 ] && echo -e "Clean $soft \t ${green}[OK]${over}"     || echo -e "Clean $soft \t ${red}[Failed]${over}"
}

readme(){
    echo '###### Generate readme ######'
    MySQL Binary: $mysql_path/bin
    MySQL DBfile: $dbfile
    MySQL Config: /etc/my.cnf
    MySQL Port:   3306
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
