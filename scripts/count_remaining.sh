#!/bin/bash

file="/home_expes/database-servers/data/reif_splitted/xzzclzp.nt"
bool=false
z=0
for f in "$1"/*;
do
	if [ "$f" = "$file" ];then
	 	echo "found it!"
		bool=true
	fi
	if [ "$bool" = true ];then
		z=`expr $z + 1` 
	fi	
done
echo "The count is : $z"
