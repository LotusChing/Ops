#!/bin/bash

test_file="/tmp/t1"
randrw_out_bw="/tmp/randrw-bw.out"
randrw_out_iops="/tmp/randrw-iops.out"
randrw_info="/tmp/randrw.txt"

randrw(){
    fio -filename=${test_file} -direct=1 -iodepth 1 -thread -rw=randrw -rwmixread=80 -ioengine=libaio -bs=4k -size=2G -numjobs=30 -runtime=100 -group_reporting -name=lotusching --output=${randrw_out_iops}

    fio -filename=${test_file} -direct=1 -iodepth 1 -thread -rw=randrw -rwmixread=80 -ioengine=libaio -bs=30M -size=2G -numjobs=30 -runtime=100 -group_reporting -name=lotusching --output=${randrw_out_bw}
    echo
    read_iops=`cat    ${randrw_out_iops} |awk -F',' '/read.*io/  {print $3}' |awk -F'=' '{print $2}'`
    write_iops=`cat   ${randrw_out_iops} |awk -F',' '/write.*io/ {print $3}' |awk -F'=' '{print $2}'`
    read_bw_avg=`cat  ${randrw_out_bw}   |awk -F',' '/read.*io/  {print $2}' |awk -F'=' '{print $2}'`
    write_bw_avg=`cat ${randrw_out_bw}   |awk -F',' '/write.*io/ {print $2}' |awk -F'=' '{print $2}'`
    echo -e "读IOPS:   \t ${read_iops}"
    echo -e "写IOPS:   \t ${write_iops}"
    echo -e "读吞吐量: \t ${read_bw_avg}"
    echo -e "写吞吐量: \t ${write_bw_avg}"
}

randrw
