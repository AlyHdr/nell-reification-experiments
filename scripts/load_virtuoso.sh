#!/bin/bash
start=`date +%s%3N`
curl -X PUT \
     -H Content-Type:text/n3 \
     -T $1 \
     --user dba:dba \
     -G http://161.3.194.53:8890/sparql-graph-crud \
     -d reif_graph
end=`date +%s%3N`
runtime=$((end-start))
echo "Loading time: $runtime"




