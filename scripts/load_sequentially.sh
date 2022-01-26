#!/bin/bash


for f in "$1"/*;
do
  echo "Loading file: $f ..."
  curl -X POST --data-binary "uri=file://$f" http://161.3.194.53:9999/blazegraph/sparql
done
