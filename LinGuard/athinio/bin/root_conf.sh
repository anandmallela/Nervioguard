#!/bin/bash/

if [ $1 == 1 ]; then
echo "`date +"%b %d %T %Y"` : INFO : Locking files command invoked" >> /var/log/osstatus.log
lvar=$(awk -F "[><]" '/param0/{print $3}' /athinio/system/param_cmd_52.xml)
if [ -e "$lvar" ]; then

chattr -R +i "$lvar"

if [ $? -eq 0 ]; then
echo "`date +"%b %d %T %Y"` : ALERT : \"$lvar\" is locked" >/athinio/system/rootconf.txt
echo "`date +"%b %d %T %Y"` : ALERT : \"$lvar\" is locked" >> /var/log/osstatus.log
rm -rf /athinio/system/param_cmd_52.xml_old*
elif [ $? -ne 0 ]; then
echo "`date +"%b %d %T %Y"` : ERROR : Can't lock the folder named \"$lvar\"" >> /var/log/osstatus.log
fi

else
echo "`date +"%b %d %T %Y"` : ERROR : Locking \"$lvar\" folder doesn't exists. Please check the folder name" >/athinio/system/rootconf.txt
echo "ERROR:\"$lvar\" folder doesn't exists. Please check the folder name..!" > /athinio/system/alertlog1.txt
echo "`date +"%b %d %T %Y"` : ERROR : Entered path \"$lvar\" is wrong" >> /var/log/osstatus.log
fi

elif [ $1 == 0 ]; then
echo "`date +"%b %d %T %Y"` : INFO : Un-locking files command invoked" >> /var/log/osstatus.log
uvar=$(awk -F "[><]" '/param0/{print $3}' /athinio/system/param_cmd_53.xml)
if [ -e "$uvar" ]; then

chattr -R -i "$uvar"

if [ $? -eq 0 ]; then
echo "`date +"%b %d %T %Y"` : INFO : \"$uvar\" is unlocked" >/athinio/system/rootconf.txt
echo "`date +"%b %d %T %Y"` : ALERT : \"$uvar\" is unlocked" >> /var/log/osstatus.log
rm -rf /athinio/system/param_cmd_53.xml_old*
elif [ $? -ne 0 ]; then
echo "`date +"%b %d %T %Y"` : ERROR : Can't un-lock the folder named \"$uvar\"" >> /var/log/osstatus.log
fi

else
echo "`date +"%b %d %T %Y"` : ERROR : Un-locking \"$uvar\" folder doesn't exists. Please check the folder name" >/athinio/system/rootconf.txt
echo "ERROR:\"$uvar\" folder doesn't exists. Please check the folder name..!" > /athinio/system/alertlog1.txt
echo "`date +"%b %d %T %Y"` : ERROR : Entered path \"$uvar\" is wrong" >> /var/log/osstatus.log
fi

fi
