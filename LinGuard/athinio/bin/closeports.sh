#!/bin/bash

netstat -tulpn | grep LISTEN > /ports.txt

awk '{print $4}' /ports.txt > /portnum.txt

awk '{print $7}' /ports.txt > /portname.txt

paste -d@ /portnum.txt /portname.txt | while IFS="@" read -r f1 f2
do
b=$(echo ${f1//*:})
#echo "$b" 
c=$(echo $f2 | cut -d '/' -f2)
 # echo "$c" 
if [ $b == 22 || $b == 80 || $b == 443 ]
then
echo "port 22 is sshd"
else

ps -elf | grep $c | awk '{print $4}' > /proces.txt
while read -r line;
do
   kill -9 "$line" ;
done < /proces.txt
echo "hello"
service $c stop
fi
done

rm -rf /ports.txt 
rm -rf /portnum.txt
rm -rf /portname.txt
