#!/bin/bash

echo "`date +"%b %d %T %Y"` : INFO : File2ban command invoked" >> /var/log/osstatus.log


jail="/etc/fail2ban/jail.local"
echo Jail $jail
sample="/var/neridio/jail.local"
echo Sample $sample
IP="/athinio/system/CONNECTEDIP"
echo IP $IP
count=$(netstat -tn 2>/dev/null | awk '{print $5}' | cut -d: -f1 | wc -l)
echo Count $count
count1=$(($count-2))
echo Count1 $count1

netstat -tn 2>/dev/null | awk '{print $5}' | cut -d: -f1 | tail -$count1 > $IP
echo IP $IP

cp -rf $sample $jail
echo "largefiles"
/athinio/bin/largefiles $IP $jail
echo "restarting"
systemctl restart fail2ban

#fail2ban-client status sshd | grep Banned | cut -d: -f2 > /BANNEDIP
sleep 60
echo "script called"
bash /athinio/bin/getbannedip.sh
