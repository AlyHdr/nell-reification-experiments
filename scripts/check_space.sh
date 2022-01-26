#!/bin/bash


while true
do
        ls -l $1 | awk '{sum += $5} END {print sum / 1000000000}' >> $2
	sleep 15m
done
