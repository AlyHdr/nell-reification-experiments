#!/bin/bash


for f in "$1"/*ng;
do
   echo "running $f"
   sh $2 $f
   sleep 5
done
