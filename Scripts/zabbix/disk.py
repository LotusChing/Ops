# coding: utf8
import sys
import time
import psutil
import subprocess

def monitor():
    # Get Disk Read/Write Sector
    dstat = subprocess.Popen('egrep "vd[a-z] |sd[a-z] |xvd[a-z] " /proc/diskstats', shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()[0].split('\n')[:-1]

    data = {
        'read_sector': dstat[0].split()[5],
        'write_sector': dstat[0].split()[9],
        'root_total_size': psutil.disk_usage('/')[0] / 1024 / 1024 / 1024,
        'root_free_size': psutil.disk_usage('/')[2] / 1024 / 1024 / 1024,
        'root_used_size': psutil.disk_usage('/')[1] / 1024 / 1024 / 1024,
        'root_used_percent': psutil.disk_usage('/')[3]
    }
    return data
if __name__ == '__main__':
    item = sys.argv[1]
    disk_info = monitor()
    print disk_info[item]
