#!/bin/bash
curl -X POST \
     -H Content-Type:text/n3 \
     -T $1 \
     -G http://localhost:6733/sparql
