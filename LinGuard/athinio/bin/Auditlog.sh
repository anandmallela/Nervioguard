#!/bin/bash

func()
{
echo "Function called!"
var=$(cat /athinio/system/auditcheck.txt)
if [[ $var == "-w /athinio -p rwxa -k athinio1 -w /rationalVault -p rwxa -k athinio2" ]]
then
echo "Auditcheck.txt file already updated!"
echo "Auditlogs Updating..!"
/usr/sbin/ausearch -k athinio --format text | uniq | egrep 'deleted|created' | egrep -v '/athinio/bin/.*' |  egrep -v '/athinio/system/.*' > /athinio/system/auditlogs.txt

else
#yum list audit audit-libs
echo "Installing Audit log dependencies..."
yum install audit audit-libs
service auditd start
service auditd status
echo "Rules applied!"
/usr/sbin/auditctl -w /athinio -p rwxa -k athinio1
/usr/sbin/auditctl -w /rationalVault -p rwxa -k athinio2
echo "Auditcheck.txt file updated!"
export values=$(auditctl -l)
echo $values > /athinio/system/auditcheck.txt
echo "Auditlogs Updating..!"
/usr/sbin/ausearch -k athinio --format text | uniq | egrep 'deleted|created' | egrep -v '/athinio/bin/.*' |  egrep -v '/athinio/system/.*'> /athinio/system/auditlogs.txt

fi
echo "Completed!"
}

if [ -e /athinio/system/auditcheck.txt ]
then
echo "Auditcheck.txt file exists!"
func
else
echo "Auditcheck.txt file not exists, going to create!"
touch /athinio/system/auditcheck.txt
func

fi
