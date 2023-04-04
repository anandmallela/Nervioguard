#!/bin/bash
rm -rf /etc/cron.daily/rkhunter
/usr/bin/rkhunter --versioncheck 2>/athinio/system/rootkitscan.txt
/usr/bin/rkhunter --update
/usr/bin/rkhunter --check --skip-keypress --report-warnings-only --summary >/athinio/system/rootkitscan.txt
b=YES

c=rootkitscan.txt

e=$(xmlstarlet ed --inplace --update "outputfile/file_status" --value "$b" /athinio/system/outputfile.xml)

f=$(xmlstarlet ed --inplace --update "outputfile/filename" --value "$c" /athinio/system/outputfile.xml)



