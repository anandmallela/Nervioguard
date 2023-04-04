#!/bin/bash/

fileName=/rationalVault/log/rationalclient.log

echo "`date +"%b %d %T %Y"` : INFO : SELinux Permissive command Invoked" >> /var/log/osstatus.log

setenforce 0

if [ $? -eq 0 ]; then

sed -i "s/\(<selinuxStatus>\)[^<]*\(<\/selinuxStatus>\)/\1`date +"%b %d %T %Y"` : INFO : SELinux Permissive mode enabled.\2/" /athinio/system/cmd_out.xml

echo "`date +"%b %d %T %Y"`:  AUDIT_LOGGING : Security system executed \"permissive\" command" >> $fileName

echo "`date +"%b %d %T %Y"` : INFO : Security system entered permissive mode" >> /var/log/osstatus.log

elif [ $? -eq 1 ]; then

sed -i 's/disabled/permissive/g' /etc/selinux/config

sed -i 's/enforcing/permissive/g' /etc/selinux/config

sed -i "s/\(<selinuxStatus>\)[^<]*\(<\/selinuxStatus>\)/\1`date +"%b %d %T %Y"` : ALERT : SELinux Permissive mode enabled. Please reboot your system to apply changes.\2/" /athinio/system/cmd_out.xml

echo "INFO:SELinux Permissive mode enabled. Please reboot your system to apply changes..!" > /athinio/system/alertlog1.txt

echo "`date +"%b %d %T %Y"`:  AUDIT_LOGGING : Security system executed \"permissive\" command" >> $fileName

echo "`date +"%b %d %T %Y"` : ALERT : Security system entered permissive mode. Reboot required" >> /var/log/osstatus.log


else
echo "`date +"%b %d %T %Y"` : ERROR : Can't execute SELinux (0) command" >> /var/log/osstatus.log
fi
