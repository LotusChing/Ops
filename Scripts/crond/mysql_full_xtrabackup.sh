#!/bin/bash
Core=`cat /proc/cpuinfo |grep processor|wc -l`
User="Lotus"
Pass=`cat /root/.pass`
Date=`date +%F`
Full_backup_dir="mysql_full_backup_${Date}"
Full_backup_file="mysql_full_backup-${Date}.tar.bz2"
Command="/usr/bin/innobackupex"
BackupServer="192.168.0.20"

backup(){
   #$Command --user=${User} --password=${Pass}  --parallel=${Core} --throttle=100 --stream=tar ./ | bzip2 - > /data/backup/${Full_backup_file}
    $Command --user=${User} --password=${Pass}  --parallel=${Core} --throttle=100  --no-timestamp /data/backup/${Full_backup_dir}
    $Command --user=${User} --password=${Pass}  --apply-log /data/backup/${Full_backup_dir}
}

send(){
    rsync -vap /data/backup/${Full_backup_dir} ${BakcupServer}:/data/
}
backup
send
