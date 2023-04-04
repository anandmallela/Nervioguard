!/bin/bash

cd /athinio/data/1cloudFiler/log

for i in $(ls)
do

a=$(grep 'ERROR\|error\|CRITICAL ERROR\|CRITICAL_ERROR' "$i") >>/var/athinio/sysError.log
echo I val $i
echo A val $a
#b= echo $a
#$b >> /var/athinio/sysError.log
done
