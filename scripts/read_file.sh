#!/bin/bash
file="/home_expes/ha07131t/queries/query_1_reif"
while IFS= read -r line
do
        # display $line or do somthing with $line
	printf '%s\n' "$line"
done <"$file"
