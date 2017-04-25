#!/bin/bash

null="/dev/null"
## OS Kernel
kernel_file="/boot/config-${kernel}"
redhat_release="/etc/redhat-release"
ubuntu_release="/etc/os-release"
[ -f /etc/redhat-release ] && os=`awk '{print $1,$3}' $redhat_release`
[ -f /etc/os-release ]     && os=`awk -F"\"" '/^P/ {print $2}' $ubuntu_release`
kernel=`awk '{print $3}' /proc/version`


### CPU
processor=`grep 'processor' /proc/cpuinfo |wc -l`
cpu_model=`grep "model name" /proc/cpuinfo|head -1 |awk -F":" '{print $2}'`
grep '^flags\b' /proc/cpuinfo | tail -1 | grep -o ht &> $null && hyper_threading=Ture || hyper_threading=False


### Memory
memory_size=`expr $(awk '/MemTotal/ {print $2}' /proc/meminfo) / 1024`


### Disk
disk_size=$(echo `awk '$4 !~ /dm/ && $2==0 || $2==16  {print $4":",$3 / 1024000 " GB"}' /proc/partitions | grep -v "sr"`)


### Network
nic_list=`egrep -v "veth|docker|lo|Inter|face" /proc/net/dev | awk '{split($1, a, ":"); print a[1]}'`
ip_list=`for i in $nic_list; do ip a s $i | awk '/inet / {split($2,a,"/"); printf a[1] ", "}'; done`


### Basic
hostname=`hostname`
ping 120.24.80.34 -c 1 -w 2 &>$null && net_type=1 || net_type=2

### Hardware
model=`dmidecode -s system-product-name|grep -v "#"`
manufacturer=`dmidecode -s system-manufacturer|grep -v "#"`
sn=`dmidecode -s system-serial-number|grep -v "#"`
uuid=`dmidecode -s system-uuid|grep -v "#"`
sku=`dmidecode -t system|grep "SKU"|awk -F':' '{print $2}'|grep -v "#"`

echo "Format Data"
server_info=`printf '{"os":"%s","kernel":"%s", "cpu_model":"%s", "processor":"%s", "hyper_threading":"%s",  "memory_size":"%s", "disk_size":"%s", "ip_list":"%s", "hostname":"%s", "net_type":"%s", "model":"%s", "manufacturer":"%s", "sn":"%s", "uuid":"%s", "sku":"%s"}\n' "$os" "$kernel" "$cpu_model" "$processor" "$hyper_threading" "$memory_size" "$disk_size" "$ip_list" "$hostname" "$net_type" "$model" "$manufacturer" "$sn" "$uuid" "$sku"`
echo "$server_info"

#echo "Post Data"
#curl -H "Content-Type: application/json" -X POST -d "$server_info" http://127.0.0.1:5002/server/reports
