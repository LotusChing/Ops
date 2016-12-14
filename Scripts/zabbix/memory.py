# coding=utf8
import sys
def monitor():
    f = open('/proc/meminfo')
    memory_info = f.readlines()
    memory_item_info = {}
    for item in memory_info:
        item = item.strip('\n').split()
        memory_item_info[item[0].strip(':')] = int(item[1])/1024
    return memory_item_info
    
if __name__ == '__main__':
    item = sys.argv[1]
    memory_item_info = monitor()
    print memory_item_info[item]
