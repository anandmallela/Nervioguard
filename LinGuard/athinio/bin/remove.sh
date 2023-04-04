#!/bin/bash

echo "`date +"%b %d %T %Y"` : INFO : Remote-Wiping command invoked for "$i"" >> /var/log/osstatus.log
i=$(awk -F "[><]" '/param0/{print $3}' /athinio/system/param_cmd_62.xml)
if [ "$i" == "/" ] || [ "$i" == "/usr" ] || [ "$i" == "/usr/bin/" ] || [ "$i" == "/usr/lib/" ] || [ "$i" == "/bin/" ] || [ "$i" == "/lib/" ] || [ "$i" == "/boot" ] || [ "$i" == "/dev" ] || [ "$i" == "/etc" ] || [ "$i" == "/mnt" ] || [ "$i" == "/mn12" ] || [ "$i" == "/media" ] || [ "$i" == "/opt" ] || [ "$i" == "/proc" ] || [ "$i" == "/root" ] || [ "$i" == "/run" ] || [ "$i" == "/sbin" ] || [ "$i" == "/var" ] || [ "$i" == "/sys" ] || [ "$i" == "/home" ]
then
    echo "`date +"%b %d %T %Y"` : ERROR : Cant remove the System folder \"$i\" folder" > /athinio/system/remotewipe.txt
    echo "ERROR:Can't remove the System folder \"$i\". Please select any other folder" > /athinio/system/alertlog1.txt
    echo "`date +"%b %d %T %Y"` : ERROR : Cant remove the System folder \"$i\" folder" >> /var/log/osstatus.log
elif [ -e "$i" ]
then
  if [ -d "$i" ]; then
     echo "Folder exists: \"$i\""
     lsattr -l  "$i" | grep -i immutable > /imm
     lsattr -ld  "$i" | grep -i immutable >> /imm

if [[ ! -z $(grep '[^[:space:]]' /imm) ]] ; then
     echo "`date +"%b %d %T %Y"` : ALERT : Can't remove \"$i\" folder. It contains immutable files" > /athinio/system/remotewipe.txt
     echo "ALERT:Can't remove \"$i\" folder. It contains immutable files" > /athinio/system/alertlog1.txt
     echo "`date +"%b %d %T %Y"` : ALERT : Can't remove \"$i\" folder. It containes immutable files" >> /var/log/osstatus.log
 
else
     rm -rf "$i"
     if [ $? -eq 0 ]; then
     echo "`date +"%b %d %T %Y"` : ALERT : \"$i\" folder is removed" > /athinio/system/remotewipe.txt
     echo "`date +"%b %d %T %Y"` : ALERT : \"$i\" folder is removed through Remote-Wiping" >> /var/log/osstatus.log
     elif [ $? -ne 0 ]; then
     echo "`date +"%b %d %T %Y"` : ERROR : Can't remove \"$i\" folder. Please check the remove command" >> /var/log/osstatus.log
     fi
fi
else
   echo "`date +"%b %d %T %Y"` : ERROR : \"$i\" folder not exists! Please give folder name" > /athinio/system/remotewipe.txt
   echo "ERROR:\"$i\" folder not exists for Remove-Wiping. Please give the folder name..!" > /athinio/system/alertlog1.txt
   echo "`date +"%b %d %T %Y"` : ERROR : Folder \"$i\" not exists. Please give the folder name" >> /var/log/osstatus.log

fi
else
   echo "`date +"%b %d %T %Y"` : ERROR : \"$i\" folder not exists! Please check the folder name" > /athinio/system/remotewipe.txt
   echo "ERROR:\"$i\" folder doesn't exists for Remove-Wiping. Please check the folder name..!" > /athinio/system/alertlog1.txt
   echo "`date +"%b %d %T %Y"` : ERROR : Folder \"$i\" not exists for Remote-Wiping" >> /var/log/osstatus.log
fi
