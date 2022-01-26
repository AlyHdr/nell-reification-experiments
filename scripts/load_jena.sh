#!/bin/bash
start=`date +%s%3N`
curl -X PUT \
     -H Content-Type:text/n3 \
     -T $1 \
     -G http://161.3.194.53:3030/ds/data \
     -d default
end=`date +%s%3N`
runtime=$((end-start))
echo "Loading time: $runtime"




