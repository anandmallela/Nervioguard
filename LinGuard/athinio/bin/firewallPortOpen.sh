#!/bin/bash

service firewalld start
fileName=/rationalVault/log/rationalclient.log

firewall-cmd --add-port=$1/tcp

output=$(firewall-cmd --list-all | grep "ports" | head -1 | cut -b 10-)
echo $output
#sed -i "s/\(<firewallOpenPorts>\)[^<]*\(<\/firewallOpenPorts>\)/\1$output\2/" /athinio/system/cmd_out.xml
/athinio/bin/getfireportinfo $output
var=$(awk '/<Ports_Available>/ { print }' /athinio/system/fireportinfo.xml | cut -d ">" -f2 | cut -d "<" -f1)
echo `date +"%b %d %T %Y"`:  AUDIT_LOGGING : Security System executed command for opening firewall port "$1" >> $fileName
echo $var
hai=${var:1:-1}
echo $hai | sed 's/,//g' > /athinio/system/firewallportinfo.txt
#sed -i  "s/\(<Ports_Available>\)[^<]*\(<\/Ports_Available>\)/\1\`"$hai"\`\2/" /athinio/system/fireportinfo.xml
#var1=(echo "${var//]}") 
#echo $var1
#var2=(echo "${var1//[}") 
#echo $var2
rm -rf /athinio/system/param_cmd_54_55.xml_old*

service firewalld stop
