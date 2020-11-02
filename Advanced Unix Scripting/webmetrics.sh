#!/bin/bash

##NAME: NARIMAN ZENDEHROOH KERMANI
##ID: 260700556

#Cleanup function
cleanup() {
	rm $(find -name webdirtydates.txt)
	rm $(find -name webcleandates.txt)
	rm $(find -name webmetricstemps.txt)
	rm $(find -name webmetricsip.txt)
	rm $(find -name webfirstcut.txt)
	rm $(find -name webmetricsidlist.txt)
	rm $(find -name webfinallist.txt)
}
if [[ $# -ne 1 ]]
then
	echo 'Error: No log file given.'
	echo 'Usage: ./webmetrics.sh <logfile>'
	exit 1
elif [[ ! -f "$1" ]]
then
	echo "Error: File '$1' does not exist."
	echo "Usage: ./webmetrics.sh <logfile>"
	exit 2
else
	#Number of requests per web browser
	safari=`grep -o 'Safari' $1 | wc -l`
	firefox=`grep -o 'Firefox' $1 | wc -l`
	chrome=`grep -o 'Chrome' $1 | wc -l`
	echo 'Number of requests per web browser'
	echo "Safari,$safari"
	echo "Firefox,$firefox"
	echo "Chrome,$chrome"
	#Numbr of distinct users per day
	awk -F: '{ print $1}' < $1 > webdirtydates.txt
	awk -F[ '{ print $2}' < webdirtydates.txt > webcleandates.txt
	dates=`sort -u webcleandates.txt`
	echo ''
	echo 'Number of distinct users per day'
	for d in $dates
	do
		grep $d $1 > webmetricstemps.txt
		grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' webmetricstemps.txt > webmetricsip.txt
		count=`sort -u webmetricsip.txt | wc -l`
		echo "$d,$count" 
	done
	#Top 20 popular product requests
	echo ''
	echo 'Top 20 popular product requests'
	cat $1 | grep -Eo "GET /product/[0-9]{1,5}" > webfirstcut.txt
	awk -F/ '{ print $3 }' < webfirstcut.txt | sort | uniq -c | sort -nr -k1 -k2 > webmetricsidlist.txt
	awk '{ print $2 "," $1 }' < webmetricsidlist.txt > webfinallist.txt
	cat webfinallist.txt | head -20
	cleanup
	exit 0
fi
