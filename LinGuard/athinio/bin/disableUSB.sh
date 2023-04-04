#!/bin/bash

kernalV=$(uname -r)
echo $kernalV
kernalV1="rename-${kernalV}"

path="/lib/modules/$kernalV"
path1="/lib/modules/$kernalV1"

if [ $1 == 0 ]; then
echo "`date +"%b %d %T %Y"` : INFO : Disable USB command invoked" >> /var/log/osstatus.log

mv $path $path1

if [ $? -eq 0 ]; then

sed -i "s/\(<status>\)[^<]*\(<\/status>\)/\1`date +"%b %d %T %Y"` : ALERT : USB Disabled. Please reboot your system to apply changes.\2/" /athinio/system/USBstatus.xml

echo "ALERT:USB was disabled in your system. Please reboot your system to apply changes..!" > /athinio/system/alertlog1.txt
echo "`date +"%b %d %T %Y"` : SUCCESS : Disable USB command executed" >> /var/log/osstatus.log
elif [ $? -ne 0 ]; then
echo "`date +"%b %d %T %Y"` : ERROR : Can't disable USB in this system. Please check Kernel Module loaded or not!" >> /var/log/osstatus.log
fi

elif [ $1 == 1 ]; then
echo "`date +"%b %d %T %Y"` : INFO : Enable USB command invoked" >> /var/log/osstatus.log

mv $path1 $path

if [ $? -eq 0 ]; then
sed -i "s/\(<status>\)[^<]*\(<\/status>\)/\1`date +"%b %d %T %Y"` : ALERT : USB Enabled. Please reboot your system to apply changes.\2/" /athinio/system/USBstatus.xml
echo "ALERT:USB was enabled in your system. Please reboot your system to apply changes..!" > /athinio/system/alertlog1.txt
echo "`date +"%b %d %T %Y"` : SUCCESS : Enable USB command executed" >> /var/log/osstatus.log
elif [ $? -ne 0 ]; then
sed -i "s/\(<status>\)[^<]*\(<\/status>\)/\1`date +"%b %d %T %Y"` : INFO : USB Enabled in your System.\2/" /athinio/system/USBstatus.xml
echo "`date +"%b %d %T %Y"` : ALERT : USB Enabled only in your System." >> /var/log/osstatus.log
fi

fi
