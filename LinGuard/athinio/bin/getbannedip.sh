#!/bin/bash

BANIP="/athinio/system/BANNEDIP"
path="/var/neridio"
echo BanIp $BANIP
echo Path $path

if [ ! -d $path ]
then
    mkdir -p $path
    chmod -R 0777 $path
fi


fail2ban-client status sshd | grep Banned | cut -d: -f2 > $BANIP
echo BanIp $BANIP

CurFail=$(fail2ban-client status sshd | grep Currently | grep failed | cut -d: -f2)
echo CurFail $CurFail
TOtFail=$(fail2ban-client status sshd | grep Total | grep failed | cut -d: -f2)
echo TOtFail $TOtFail
CurBan=$(fail2ban-client status sshd | grep Currently | grep banned | cut -d: -f2)
echo CurBan $CurBan
TotBan=$(fail2ban-client status sshd | grep Total | grep banned | cut -d: -f2)
echo TotBan $TotBan
#echo $CurFail $TOtFail $CurBan $TotBan

#rm -rf /var/neridio/banned_ip.xml

/athinio/bin/largefiles $BANIP $CurFail $TOtFail $CurBan $TotBan

echo "`date +"%b %d %T %Y"` : INFO : File2ban command executed" >> /var/log/osstatus.log
