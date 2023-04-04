#!/bin/bash/

output=$(systemctl status firewalld.service | awk '/Active/ {print $2}')
#echo $output
sed -i "s/\(<firewallStatus>\)[^<]*\(<\/firewallStatus>\)/\1$output\2/" /athinio/system/cmd_out.xml

