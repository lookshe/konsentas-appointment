#!/bin/bash

cd $(dirname $0)

AUTHORITY_ID=ENTER_AUTHORITY_ID_HERE
PROCESS_ID=ENTER_PROCESS_ID_HERE

date >> "check.out"
./check.sh >> "check.out"
