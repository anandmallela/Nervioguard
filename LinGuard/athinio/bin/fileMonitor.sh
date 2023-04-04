#!/bin/bash

echo "`date +"%b %d %T %Y"` : INFO : File Monitor Start command invoked" >> /var/log/osstatus.log

rm -rf /var/log/monitor.log

rm -rf /athinio/system/filemonitor_start_error.txt

DIR=$1
currenttime=$(date)
if [ ! -d "$DIR" ];then
echo "hello"
sed -i "s/\(<monitoringstatus>\)[^<]*\(<\/monitoringstatus>\)/\10\2/" /athinio/system/monitorstatus.xml
echo "`date +"%b %d %T %Y"` : ALERT :Entered path \"$1\" for filemonitor not exists" > /athinio/system/filemonitor_start_error.txt
echo "ALERT:Entered path \"$1\" for filemonitor not exists" > /athinio/system/alertlog1.txt
 echo "`date +"%b %d %T %Y"` : ERROR : Entered path \"$1\" for filemonitor not exists" >> /var/log/osstatus.log
fi


monitor(){
    local line=$1
#echo a is "$line"
 grep -qFx "$line" /var/log/monitor.log ||    echo `date +"%b %d %T %Y"`: MONITOR_LOGGING : Adding $line to monitering.. >> /var/log/monitor.log
/athinio/bin/monitor $line
}

find $1 -type d > FILESTOMONITOR
 while IFS="" read -r line || [ -n "$line" ]
 do
   monitor "$line" &
 done < FILESTOMONITOR


ps -ef | grep "bash /athinio/bin/fileMonitor.sh $1" > filename.txt
sed -i '$ d' filename.txt
sed -i '1d' filename.txt
awk '{print $2}' filename.txt > FILEID


while IFS="" read -r p || [ -n "$p" ]
do
 kill -9 $p
 echo $p
done < FILEID
