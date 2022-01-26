#!/bin/bash


query=`cat $1`

echo "Running Query..."


query_test="select * {?s ?p ?o} LIMIT 100"

#run queries by argument

if [ $1 = 't' ]
then
	echo "Running test query..."
	query=$query_test
fi

start=`date +%s%3N`

curl -X POST http://161.3.194.53:9999/blazegraph/sparql --max-time 120 --data-urlencode "query=$query" -H 'Accept:application/rdf+xml' 
#> /dev/null 2>&1
end=`date +%s%3N`
runtime=$((end-start))

echo "Run time: $runtime"
