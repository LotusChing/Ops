#!/bin/bash

######这些变量主要为了获取到本周一的全备文件路径######
Backupdir="/data/backup"
Monday=`date -d "last monday" +%F`
Backupfile="${Backupdir}/mysql_full_backup-${Monday}.tar.bz2"
Fulldir="/data/backup/full-backup-${Monday}"
Command="/usr/bin/innobackupex"

######这些变量为执行备份时所需的认证信息######
Core=`cat /proc/cpuinfo |grep processor|wc -l`
User="Lotus"
Pass="Ching"
Date=`date +%F`
incrdir="/data/backup/incremental-${Date}"

pre(){
    tar xif ${Backupfile} -C ${Fulldir}
}

incremental(){
   ${Command} --user=Lotus --password=Ching --no-timestamp --parallel=${Core} --throttle=100 --incremental ${incrdir} --incremental-basedir=${Fulldir} 
}

incremental
