#!/bin/bash


query=`cat $1`
query_name=`basename $1`

echo "Running Query..."


query_test="select * {?s ?p ?o} LIMIT 100"

#run queries by argument

if [ $1 = 't' ]
then
	echo "Running test query..."
	query=$query_test
fi
start=`date +%s%3N`
curl -G --max-time 120 --data-urlencode "query=$query" http://161.3.194.53:7200/repositories/repo1 
#>> /dev/null 2>&1
end=`date +%s%3N`
runtime=$((end-start))
echo "run time: $runtime"
