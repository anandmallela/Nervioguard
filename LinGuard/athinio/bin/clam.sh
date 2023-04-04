#!/bin/bash/

rm -rf /athinio/system/clam_error.txt

cvar=$(awk -F "[><]" '/param0/{print $3}' /athinio/system/param_cmd_51.xml)

echo "`date +"%b %d %T %Y"` : INFO : Antivirus command is invoked \"$cvar\"" >> /var/log/osstatus.log

> /athinio/system/clamlogfile.txt

if [ -e "$cvar" ]; then

clamscan -i -r --log=/athinio/system/clamlogfile.txt --scan-pe=yes --scan-elf=yes --scan-ole2=yes --scan-pdf=yes --scan-swf=yes --scan-html=yes --scan-xmldocs=yes --scan-hwp3=yes --scan-archive=yes "$cvar" && output=$(sed -n /Infected\ files:/p /athinio/system/clamlogfile.txt) && /athinio/bin/getclamstatus "$cvar" $output

if [ $? -eq 0 ]; then
rm -rf /athinio/system/param_cmd_51.xml_old*
echo "`date +"%b %d %T %Y"`: AUDIT_LOGGING : Security system scanned the path \"$cvar\"" >> /rationalVault/log/rationalclient.log
echo "`date +"%b %d %T %Y"` : ALERT : Security system scanned the path \"$cvar\"" >> /var/log/osstatus.log
elif [ $? -ne 0 ]; then
echo "`date +"%b %d %T %Y"` : ERROR : Can't scan the entered path" >> /var/log/osstatus.log
fi

else
echo "`date +"%b %d %T %Y"` : ERROR : Entered path \"$cvar\" is wrong" >> /var/log/osstatus.log
echo "`date +"%b %d %T %Y"` : ERROR : Entered path \"$cvar\" for Antivirus is not exists. Please check the folder name..!" > /athinio/system/clam_error.txt
echo "ERROR:Entered path \"$cvar\" for Antivirus is not exists. Please check the folder name..!" > /athinio/system/alertlog1.txt
fi
