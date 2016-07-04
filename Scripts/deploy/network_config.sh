#!/bin/bash
ifcfg="/etc/sysconfig/network-scripts/ifcfg-eth0"
udev="/etc/udev/rules.d/70-persistent-net.rules"

Device=`ip a|grep eth.*state.*UP|awk {'print $2'}|awk -F':' '{print $1}'`
UDev_Mac=`cat ${udev}  |tail -1|awk -F'"' '{print $8}'`
Local_IP=`ip a s ${Device} | grep 'inet ' |awk '{ split($2,a,"/"); print a[1]}'`
Local_Mac=`ip a|grep 'link/ether'|awk '{print $2}'`
Local_GW=`ip r|tail -1 |awk {'print $3'}`

inital(){
    echo "====== Inital ======"
    iptables -F && service iptables save &>/dev/null && echo "Clean Iptables OK"
    echo "setenforce 0" >>/etc/rc.local              && echo "Selinux Permissive OK"
    /sbin/chkconfig NetworkManager off               && echo "Disable NM OK"
    echo -e "Done.\n"
}

interface_conf(){
echo "======Generate ifcfg======"
    cat > ${ifcfg} << EOF
DEVICE=eth0
TYPE=Ethernet
ONBOOT=yes
BOOTPROTO=none
IPADDR=${Local_IP}
GATEWAY=${Local_GW}
EOF
echo -e "Done.\n"
}

backup(){
    echo "====== BackupFile ======"
    cp -f ${ifcfg}{,.bak} && echo "copy to ifcfg bak OK"
    cp -f ${udev}{,.bak}  && echo "copy to udev  bak OK"
    echo -e "Done.\n"
}

udev_conf(){
echo "======Generate ifcfg======"
    echo `grep ${Local_Mac} ${udev}.bak |awk -F'eth[0-9]' '{print $1}'`eth0\" > ${udev}
echo -e "Done.\n"
}
inital
backup
interface_conf
udev_conf
