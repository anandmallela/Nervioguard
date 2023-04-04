#!/bin/bash


echo "`date +"%b %d %T %Y"` :  AUDIT_LOGGING : Security system executed shutdown command" >> /rationalVault/log/rationalclient.log

echo "`date +"%b %d %T %Y"` : ALERT : Security system going to \"shutdown\" your system" >> /var/log/osstatus.log

/sbin/shutdown now

if [ $? -ne 0 ]; 
then
echo "`date +"%b %d %T %Y"` :  ERROR : Cant execute \"shutdown\" command" >> /var/log/osstatus.log
fi
