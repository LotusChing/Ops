# coding:utf8
import sys
import time
import psutil
import subprocess

def monitor(interval=2):
    cpu_utilization = psutil.cpu_percent()

    ### Get 1,5,15 server load
    server_load = subprocess.Popen("uptime | awk -F ':' '{print $NF}'", shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()[0].strip().strip('\n').split(', ')

    ### Get CPU Utilization info
    f = open('/proc/stat')
    cpu_t1 = f.readline().strip('\n').strip('cpu+').split()
    time.sleep(interval)
    f = open('/proc/stat')
    cpu_t2 = f.readline().strip('\n').strip('cpu+').split()   

    ### Get CPU Use percent
    cpu_total_t1 = float(eval('+'.join(cpu_t1))) 
    cpu_total_t2 = float(eval('+'.join(cpu_t2)))
    cpu_idle_t1 = float(cpu_t1[4])
    cpu_idle_t2 = float(cpu_t2[4])
    cpu_idle_diff = cpu_idle_t2-cpu_idle_t1
    cpu_total_diff = cpu_total_t2-cpu_total_t1
    cpu_percent = (cpu_total_diff- cpu_idle_diff) / cpu_total_diff

    ### Plus 2 sec cpu item avg value
    cpu_total = [str(int(x) + int(y) / 2) for x, y in zip(cpu_t1, cpu_t2)]
    cpu_total_time = float(eval('+'.join(cpu_total)))

    ### Calculate percentage
    cpu_item_usage = [int(cpu_item) / cpu_total_time * 100 for cpu_item in cpu_total]
   
    ### CPU Item Dict
    cpu_info = {
        'user_space_percent': round(cpu_item_usage[0]),
        'system_space_percent' : round(cpu_item_usage[2]),
        'idle_percent': round(cpu_item_usage[3]),
        'iowait_percent': round(cpu_item_usage[4]),
        'cpu_percent' : round(cpu_percent),
        '1m_load': server_load[0],
        '5m_load': server_load[1],
        '15m_load': server_load[2]
    }
    return cpu_info

if __name__ == '__main__':
    item = sys.argv[1]
    cpu_util_info = monitor()
    print cpu_util_info[item]
