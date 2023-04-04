#!/bin/bash

Logfile=/rationalVault/log/rationalclient.log
#echo>/tmp/rclienttmp.log
grep 'ERROR\|error\|CRITICAL ERROR\|CRITICAL_ERROR' $Logfile > /home/athinio/data/1cloudFiler/log/rclienttmp.log

