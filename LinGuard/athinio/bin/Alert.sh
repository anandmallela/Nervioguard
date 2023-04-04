#!/bin/bash
bash /athinio/bin/rcheck1.sh
##date.............###
date=$(date '+%Y-%m-%d %H:%M:%S')
sed -i "s/\(<Current_date_and_time>\)[^<]*\(<\/Current_date_and_time>\)/\1$date\2/" /athinio/system/alertlog.xml

##storage..........###
storage=$(df / | grep / | awk '{ print $5}' | sed 's/%//g')
echo $storage
sed -i "s/\(<Disk_current_value>\)[^<]*\(<\/Disk_current_value>\)/\1$storage\2/" /athinio/system/alertlog.xml

##processs.........###
process=$(ps -aux | wc -l)
echo $process
sed -i "s/\(<Process_current_value>\)[^<]*\(<\/Process_current_value>\)/\1$process\2/" /athinio/system/alertlog.xml

##RAM.........######
free > /athinio/system/12.txt
secondLine=$(sed -n '2p' /athinio/system/12.txt)
echo $secondLine
read -ra ADDR <<< "$secondLine"
totalRam="${ADDR[1]}"
usedRam="${ADDR[2]}"
pct="$(($usedRam*100/$totalRam))"
echo "$pct" 
sed -i "s/\(<RAM_current_value>\)[^<]*\(<\/RAM_current_value>\)/\1$pct\2/" /athinio/system/alertlog.xml

##LIBRARY FILES.........######
find /lib -mtime -1 -ls | awk '{print $NF}' >/athinio/system/libmodify.txt
find /usr/lib -mtime -1 -ls | awk '{print $NF}' >>/athinio/system/libmodify.txt
line=$(cat /athinio/system/libmodify.txt | wc -l)
if [ $line -ge 1 ]
then
sed -i "s/\(<Lib_current_status>\)[^<]*\(<\/Lib_current_status>\)/\11\2/" /athinio/system/alertlog.xml
else
sed -i "s/\(<Lib_current_status>\)[^<]*\(<\/Lib_current_status>\)/\10\2/" /athinio/system/alertlog.xml
fi

##BINARY FILES.........######
find /bin -mtime -1 -ls | awk '{print $NF}' >/athinio/system/binmodify.txt
find /usr/bin -mtime -1 -ls | awk '{print $NF}' >>/athinio/system/binmodify.txt
line=$(cat /athinio/system/binmodify.txt | wc -l)
if [ $line -ge 1 ]
then
sed -i "s/\(<Bin_current_status>\)[^<]*\(<\/Bin_current_status>\)/\11\2/" /athinio/system/alertlog.xml
else
sed -i "s/\(<Bin_current_status>\)[^<]*\(<\/Bin_current_status>\)/\10\2/" /athinio/system/alertlog.xml
fi

##SELINUX STATUS......######
/bin/bash /athinio/bin/sestatus.sh
