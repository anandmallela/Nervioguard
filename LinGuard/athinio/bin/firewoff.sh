#!/bin/bash

fileName=/rationalVault/log/rationalclient.log

systemctl stop firewalld.service

bash /athinio/bin/firestatus.sh

echo `date +"%b %d %T %Y"`:  AUDIT_LOGGING : Security System executed "systemctl stop firewalld.service" command >> $fileName
