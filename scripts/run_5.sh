#!/bin/bash

counter=1
while [ $counter -le 5 ]
do
  sh $1 $2
  counter=`expr $counter + 1`
done
