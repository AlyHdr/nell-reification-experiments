#!/bin/bash
echo "Loading file..."
start=`date +%s%3N`

curl -X POST --data-binary "uri=file://$1" http://161.3.194.53:9999/blazegraph/sparql
#sleep 5
end=`date +%s%3N`
runtime=$((end-start))
echo "Finished file... runtime : $runtime"
