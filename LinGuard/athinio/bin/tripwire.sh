#!/bin/bash

yum install epel-release -y
yum update -y
yum install expect -y

yum install tripwire -y

expect /athinio/bin/tripwire-KEY1.sh
#expect tripwire-KEY2.sh
echo -ne '\n' | tripwire --init
sh -c 'tripwire --check | grep Filename > trip.txt'

for f in $(grep "Filename:" trip.txt | cut -f2 -d:); do
sed -i "s|\($f\) |#\\1|g" /etc/tripwire/twpol.txt
done

expect /athinio/bin/tripwire-KEY3.sh

echo -ne '\n' | tripwire --init
#expect tripwire-KEY5.sh
tripwire --check
