#!/bin/bash

Repo_dir="/etc/yum.repos.d"
Null="/dev/null"
repo(){
echo "====== Yum ======"
mkdir ${Repo_dir}/default
mv ${Repo_dir}/* ${Repo_dir}/default/ &> ${Null}
echo "Download yum file..."
wget forever.felicity.family/deploy/yum/ali-yum.tar.gz &> ${Null}
tar xf ali-yum.tar.gz -C ${Repo_dir}/ &> ${Null}
echo "Download Done."
echo "Clean yum cache."
yum clean all &> ${Null}
echo "Flush repositories..."
yum repolist &> ${Null} && echo "Yum Configure Successful." || echo "Yum Configure with problem"
rm -f ali-yum.tar.gz
}

limit(){
echo "====== ulimit ======"
echo "Setting file limit"
cat >> /etc/security/limits.conf << EOF
root soft nofile 65535
root hard nofile 65535
* soft nofile 65535
* hard nofile 65535
EOF
echo "Setting Done."
}

network(){
echo "====== FireWall ======"
echo "Clean default rules..."
iptables -F
setenforce 0
service iptables save &> ${Null}
echo "Clean Done."
}

base_package(){
echo "====== Package ======"
echo "Install Base Package..."
yum -y install \
       lrzsz   \
       nethogs \
       htop    \
       elinks  \
       screen  \
       git     \
       nc      \
       nmap    \
       telnet  &> ${Null}
[ $? -eq 0 ] && echo "Install Success." || echo "Install with problem." 
}

go(){
   # repo
    limit
    network
    base_package 
}
$1
