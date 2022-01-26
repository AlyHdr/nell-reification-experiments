#!/bin/bash
curl -X POST http://localhost:9999/blazegraph/sparql --data-urlencode 'update=DROP ALL'
