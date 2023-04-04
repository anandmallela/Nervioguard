#!/bin/bash

fileName=/rationalVault/log/rationalclient.log

echo "`date +"%b %d %T %Y"` : INFO : SELinux Enforcing command Invoked" >> /var/log/osstatus.log

setenforce 1

if [ $? -eq 0 ]; then

sed -i "s/\(<selinuxStatus>\)[^<]*\(<\/selinuxStatus>\)/\1`date +"%b %d %T %Y"` : ALERT : SELinux Enforcing mode enabled.\2/" /athinio/system/cmd_out.xml

echo "`date +"%b %d %T %Y"`:  AUDIT_LOGGING : Security system executed \"enforcing\" command" >> $fileName

echo "`date +"%b %d %T %Y"` : ALERT : Security system entered \"enforcing\" mode" >> /var/log/osstatus.log

elif [ $? -eq 1 ]; then

sed -i 's/disabled/enforcing/g' /etc/selinux/config

sed -i 's/permissive/enforcing/g' /etc/selinux/config

sed -i "s/\(<selinuxStatus>\)[^<]*\(<\/selinuxStatus>\)/\1`date +"%b %d %T %Y"` : ALERT : SELinux Enforcing mode enabled. Please reboot your system to apply changes.\2/" /athinio/system/cmd_out.xml

echo "ALERT:SELinux Enforcing mode enabled. Please reboot your system to apply changes..!" > /athinio/system/alertlog1.txt

echo "`date +"%b %d %T %Y"`:  AUDIT_LOGGING : Security system executed \"enforcing\" command" >> $fileName

echo "`date +"%b %d %T %Y"` : ALERT : Security system entered \"enforcing\" mode. Reboot required." >> /var/log/osstatus.log


else
echo "`date +"%b %d %T %Y"` : ERROR : Can't execute SELinux (1) command" >> /var/log/osstatus.log
fi
