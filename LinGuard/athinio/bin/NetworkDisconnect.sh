#!/bin/bash

/bin/systemctl stop network

echo "`date +"%b %d %T %Y"`: AUDIT_LOGGING : Security system disconnected Network service" >> /rationalVault/log/rationalclient.log
echo "`date +"%b %d %T %Y"` : INFO : Security system disconnected Network service"  >> /var/log/osstatus.log
