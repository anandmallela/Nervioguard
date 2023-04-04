#!/bin/bash

new=$(awk '/<device>/ { print }' /athinio/system/param_cmd_92.xml | cut -d ">" -f2 | cut -d "<" -f1)
echo $new


echo=$(sed -n '7p' /athinio/system/tripwireNewPolicy.txt)
echo $echo

old=${echo::-16}
echo $old

sed -i "s|$old|$new|g" /athinio/system/tripwireNewPolicy.txt

cat /athinio/system/tripwireNewPolicy.txt >> /etc/tripwire/twpol.txt

tripwire --check

cd /var/lib/tripwire/report

ab1=$(ls -Art | tail -n 1)
#echo $ab1

twprint --print-report --twrfile /var/lib/tripwire/report/$ab1 > /athinio/system/report1.txt

line=$(awk '/Object Detail:/{ print NR; exit }' /athinio/system/report1.txt)
#echo $line

tail -n +$line /athinio/system/report1.txt > /athinio/system/report2.txt

head -n -5 /athinio/system/report2.txt > /athinio/system/report.txt
rm -rf /athinio/system/report1.txt
rm -rf /athinio/system/report2.txt


b=YES
c=report.txt
e=$(xmlstarlet ed --inplace --update "outputfile/file_status" --value "$b" /athinio/system/outputfile.xml)
f=$(xmlstarlet ed --inplace --update "outputfile/filename" --value "$c" /athinio/system/outputfile.xml)

