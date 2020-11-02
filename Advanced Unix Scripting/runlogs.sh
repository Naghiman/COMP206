#!/bin/bash

#NAME: NARIMAN ZENDEHROOH KERMANI
#ID: 260700556

#Find location of webmetrics.sh
find -name webmetrics.sh > webmetricsloc.txt
read -r SCRIPT_PATH < webmetricsloc.txt

#logs
echo 'Web metrics for log file weblog1.txt'
echo '===================='
bash $SCRIPT_PATH weblog1.txt
echo ''
echo ''
echo 'Web metrics for log file weblog2.txt'
echo '===================='
bash $SCRIPT_PATH weblog2.txt
echo ''
echo ''
echo 'Web metrics for log file weblog3.txt'
echo '===================='
bash $SCRIPT_PATH weblog3.txt
echo ''
echo ''
#cleanup
rm $(find -name webmetricsloc.txt)
