#!/bin/bash
input="/home_expes/ha07131t/scripts/log_reif_loading"
while IFS= read -r line
do
        # display $line or do somthing with $line
	echo "$line"
done < "$input"
