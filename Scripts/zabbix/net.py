# coding: utf8
import sys
import psutil
import subprocess

def monitor():
    eth1_stat = psutil.net_io_counters(pernic=True)['eth1']
    tcp_stat = subprocess.Popen('ss -s|grep "TCP:" |egrep -o  "\(.*\)"', stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True).communicate()[0].strip('\(').strip('\)\n').split(', ')
    net_data = {
        'bytes_sent': eth1_stat[0],
        'bytes_recv': eth1_stat[1],
        'packets_sent': eth1_stat[2],
        'packets_recv': eth1_stat[3],
        'estab': tcp_stat[0].split()[1],
        'closed': tcp_stat[1].split()[1],
        'timewait': tcp_stat[4].split()[1].split('/')[0]
    }
    return net_data

if __name__ == '__main__':
    item = sys.argv[1]
    net_info = monitor()
    print net_info[item]

