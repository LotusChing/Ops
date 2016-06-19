#!/bin/bash
DBUser="zabbix"
DBPass=`cat /var/lib/mysql/.mysqlpass`
DBHost="192.168.0.169"

case $1 in 
	Uptime)
	    result=`mysqladmin -u$DBUser -p$DBPass -h $DBHost status|awk -F"  " '{print $1}'|awk -F": " '{print $2}'`
	    echo $result
	;;
	
	Thread)
	    thread=`mysqladmin -u$DBUser -p$DBPass -h $DBHost status|awk -F"  " '{print $2}'|awk -F": " '{print $2}'`
            echo $thread
	;;
		
	Slow-queries)
	    slow_queries=`mysqladmin -u$DBUser -p$DBPass  -h $DBHost status|awk -F"  " '{print $4}'|awk -F": " '{print $2}'`
	    echo $slow_queries
	;;
	
	Open-tables)
	    open_tables=`mysqladmin -u$DBUser -p$DBPass -h $DBHost status|awk -F"  " '{print $7}'|awk -F": " '{print $2}'`
            echo $open_tables
	;;
	
	Per-second-query)
	    per_second_query=`mysqladmin -u$DBUser -p$DBPass -h $DBHost status|awk -F"  " '{print $NF}'|awk -F": " '{print $2}'`
	    echo $per_second_query
	;;

	*)
	    echo "Usage:$0 (Uptime|Thread|Slow-queries|Open-tables|Per-second-query)"
	;;
esac
