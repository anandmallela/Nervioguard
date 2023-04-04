#!bin/bash

echo "`date +"%b %d %T %Y"` : INFO : File Monitor Stop command invoked" >> /var/log/osstatus.log

i=$(awk -F "[><]" '/param0/{print $3}' /athinio/system/param_cmd_60_61.xml)

if [ -e "$i" ]; then

ps -elf | grep /athinio/bin/monitor | grep $i | awk '{print $4}' >/PID_KILL

while IFS="" read -r line || [ -n "$line" ]
 do
   kill "$line" &
 done < /PID_KILL
echo `date +"%b %d %T %Y"`: MONITOR_LOGGING : Removing \"$i\" from monitering..... >> /var/log/monitor.log

>/PID_KILL

else
echo "ALERT:Entered path \"$i\" for Stop-filemonitor not exists" > /athinio/system/alertlog1.txt
echo "`date +"%b %d %T %Y"` : ERROR : Entered path \"$i\" is wrong for Stop-filemonitor" >> /var/log/osstatus.log
fi
