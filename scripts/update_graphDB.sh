#!/bin/bash


curl -X POST  http://161.3.194.53:7200/repositories/repo1/statements --data-urlencode 'update=DROP ALL'
