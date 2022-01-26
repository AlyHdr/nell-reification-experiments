#!/bin/bash

for f in "$1"/*;
do
	mv $f "$f.nt"
done
