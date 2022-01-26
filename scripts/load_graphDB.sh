#!/bin/bash

curl -X POST -H "Content-Type:text/n3" -T $1  http://161.3.194.53:7200/repositories/repo1/statements
