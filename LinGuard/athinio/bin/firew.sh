#!/bin/bash

fileName=/rationalVault/log/rationalclient.log

systemctl start firewalld.service

bash /athinio/bin/firestatus.sh 

echo `date +"%b %d %T %Y"`:  AUDIT_LOGGING : Security System executed "systemctl start firewalld.service" command >> $fileName
