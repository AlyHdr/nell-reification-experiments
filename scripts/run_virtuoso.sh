#!/bin/bash


query=`cat $1`
query_name=`basename $1`
echo "Running Query..."


query_test="select (count(*) as ?count) {?s ?p ?o} LIMIT 100"

#run queries by argument

if [ $1 = 't' ]
then
	echo "Running test query..."
	query=$query_test
fi

start=`date +%s%3N`

curl -X POST http://161.3.194.53:8890/sparql --data-urlencode "query=$query" --data-urlencode 'default-graph-uri=nell.100k' --data-urlencode 'timeout=1200000'
# > /dev/null 2>&1
end=`date +%s%3N`
runtime=$((end-start))

echo "$runtime"
