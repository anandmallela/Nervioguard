#!/bin/bash

echo "FILE ACCESSED BETWEEN SPECIFIED TIME.."


####LAST 5 UPDATES HAPPENED IN THE LAST 1 HOUR IN THE SYSTEM####

if [ $1 == "-a" ]
then
echo "`date +"%b %d %T %Y"` : INFO : Last 1 Hr Recent files command invoked" >> /var/log/osstatus.log

find /* -maxdepth 10 -type f \( ! -iname AccessFile ! -iname AccessFileUser ! -iname ModifiedFile ! -iname ModifiedFileUser ! -iname ChangedFile ! -iname ChangedFileUser ! -iname LASTFIVEFILES.log ! -iname RecentFiles ! -iname LASTONEHOUR.log ! -iname LASTONEDAY.log ! -iname LASTEIGHTHOUR.log ! -iname FA1H ! -iname FM1H ! -iname FC1H ! -iname FileACCESS ! -iname fileMODIFIED ! -iname fileCHANGED \) -amin -60 -ls | head -5 | egrep -v "athinio|proc" > /athinio/system/AccessFile
if [[ $USERNAME == root ]]; then
find /$USERNAME/* -maxdepth 10 -type f ! -name "RecentFiles.*" ! -name ".RecentFiles.*" -amin -60 -ls | head -5 | egrep -v "athinio|proc" > /athinio/system/AccessFileUser
else
find /home/$USERNAME/* -maxdepth 10 -type f ! -name "RecentFiles.*" ! -name ".RecentFiles.*" -amin -60 -ls | head -5 | egrep -v "athinio|proc" > /athinio/system/AccessFileUser
fi
#cat /FA1H /AccessFile /AccessFileUser | head -6 | uniq > /fileaccess
cat /athinio/system/AccessFile /athinio/system/AccessFileUser | head -5 | uniq > /athinio/system/fileaccess
awk '{print $NF}' /athinio/system/fileaccess > /athinio/system/FILEACCESS
if [[ ! -z $(grep '[^[:space:]]' /athinio/system/FILEACCESS) ]]; then
echo -e "FILE ACCESSED BETWEEN LAST 1 HOUR.." > /athinio/system/FA1H
fi

#rm -rf /fileaccess
find /* -maxdepth 10 -type f \( ! -iname AccessFile ! -iname AccessFileUser ! -iname ModifiedFile ! -iname ModifiedFileUser ! -iname ChangedFile ! -iname ChangedFileUser ! -iname LASTFIVEFILES.log ! -iname RecentFiles ! -iname LASTONEHOUR.log ! -iname LASTONEDAY.log ! -iname LASTEIGHTHOUR.log ! -iname FA1H ! -iname FM1H ! -iname FC1H ! -iname FileACCESS ! -iname fileMODIFIED ! -iname fileCHANGED \) -mmin -60 -ls | head -5 | egrep -v "athinio|proc" > /athinio/system/ModifiedFile
if [[ $USERNAME == root ]]; then
find /$USERNAME/* -maxdepth 10 -type f ! -name "RecentFiles.*" ! -name ".RecentFiles.*" -mmin -60  -ls | head -5 | egrep -v "athinio|proc" > /athinio/system/ModifiedFileUser
else
find /home/$USERNAME/* -maxdepth 10 -type f ! -name "RecentFiles.*" ! -name ".RecentFiles.*" -mmin -60  -ls | head -5 | egrep -v "athinio|proc" > /athinio/system/ModifiedFileUser
fi

#cat /FM1H /ModifiedFile /ModifiedFileUser | head -5 | uniq > /fileMODIFIED
cat /athinio/system/ModifiedFile /athinio/system/ModifiedFileUser | head -5 | uniq > /athinio/system/filemodified
awk '{print $NF}' /athinio/system/filemodified > /athinio/system/FILEMODIFIED
if [[ ! -z $(grep '[^[:space:]]' /athinio/system/FILEMODIFIED) ]]; then
echo -e "FILE MODIFIED BETWEEN LAST 1 HOUR.." > /athinio/system/FM1H
fi

find /* -maxdepth 10 -type f \( ! -iname AccessFile ! -iname AccessFileUser ! -iname ModifiedFile ! -iname ModifiedFileUser ! -iname ChangedFile ! -iname ChangedFileUser ! -iname LASTFIVEFILES.log ! -iname RecentFiles ! -iname LASTONEHOUR.log ! -iname LASTONEDAY.log ! -iname LASTEIGHTHOUR.log ! -iname FA1H ! -iname FM1H ! -iname FC1H ! -iname FileACCESS ! -iname fileMODIFIED ! -iname fileCHANGED \) -cmin -60 -ls | head -5 | egrep -v "athinio|proc" > /athinio/system/ChangedFile
if [[ $USERNAME == root ]]; then
find /$USERNAME/* -maxdepth 10 -type f ! -name "RecentFiles.*" ! -name ".RecentFiles.*" -cmin -60  -ls | head -5 | egrep -v "athinio|proc" > /athinio/system/ChangedFileUser
else
find /home/$USERNAME/* -maxdepth 10 -type f ! -name "RecentFiles.*" ! -name ".RecentFiles.*" -cmin -60  -ls | head -5 | egrep -v "athinio|proc" > /athinio/system/ChangedFileUser
fi

#cat /FC1H /ChangedFile /ChangedFileUser | head -6 | uniq > /fileCHANGED
cat /athinio/system/ChangedFile /athinio/system/ChangedFileUser | head -5 | uniq > /athinio/system/filechanged
awk '{print $NF}' /athinio/system/filechanged > /athinio/system/FILECHANGED
if [[ ! -z $(grep '[^[:space:]]' /athinio/system/FILECHANGED) ]]; then
echo -e "FILE CHANGED BETWEEN LAST 1 HOUR.." > /athinio/system/FC1H
fi

#cat /FileACCESS /fileMODIFIED /fileCHANGED | uniq > /LASTONEHOUR.log

cat /athinio/system/FA1H /athinio/system/FILEACCESS /athinio/system/FM1H /athinio/system/FILEMODIFIED /athinio/system/FC1H  /athinio/system/FILECHANGED | uniq > /athinio/system/LASTONEHOUR.log
#[ -s /athinio/system/LASTONEHOUR.log ]
#chkEmp=$?
#if [ $chkEmp == 1 ]
if [[ -z $(grep '[^[:space:]]' /athinio/system/LASTONEHOUR.log) ]]; then
        echo "THERE IS NO LAST 5 UPDATES HAPPENED IN THE LAST 1 HOUR IN THE SYSTEM.."
else
echo ""
echo "`date +"%b %d %T %Y"` : INFO : Last 1 Hr Recent files command executed" >> /var/log/osstatus.log
echo -e "LAST 5 UPDATES HAPPENED IN THE LAST 1 HOUR IN THE SYSTEM..\n"
cat /athinio/system/LASTONEHOUR.log
echo ""
fi

echo "Removing all files which all are created..!"
rm -rf /athinio/system/FA1H
rm -rf /athinio/system/AccessFile
rm -rf /athinio/system/AccessFileUser
rm -rf /athinio/system/fileaccess
rm -rf /athinio/system/FILEACCESS
rm -rf /athinio/system/FM1H
rm -rf /athinio/system/ModifiedFile
rm -rf /athinio/system/ModifiedFileUser
rm -rf /athinio/system/filemodified
rm -rf /athinio/system/FILEMODIFIED
rm -rf /athinio/system/FC1H
rm -rf /athinio/system/ChangedFile
rm -rf /athinio/system/ChangedFileUser
rm -rf /athinio/system/filechanged
rm -rf /athinio/system/FILECHANGED

fi
#####


if [ $1 == "-b" ]
then
echo "`date +"%b %d %T %Y"` : INFO : Recent 5 files command invoked" >> /var/log/osstatus.log

find /* -maxdepth 10 -type f \( ! -iname AccessFile ! -iname AccessFileUser ! -iname ModifiedFile ! -iname ModifiedFileUser ! -iname ChangedFile ! -iname ChangedFileUser ! -iname LASTFIVEFILES.log ! -iname RecentFiles ! -iname LASTONEHOUR.log ! -iname LASTONEDAY.log ! -iname LASTEIGHTHOUR.log ! -iname FA1H ! -iname FM1H ! -iname FC1H ! -iname FileACCESS ! -iname fileMODIFIED ! -iname fileCHANGED \) -amin 0.1 -ls | head -5 | egrep -v "athinio|proc" > /athinio/system/AccessFile
if [[ $USERNAME == root ]]; then
find /$USERNAME/* -maxdepth 10 -type f ! -name "RecentFiles.*" ! -name ".RecentFiles.*" -amin 0.1 -ls | head -5 | egrep -v "athinio|proc" > /athinio/system/AccessFileUser
else
find /home/$USERNAME/* -maxdepth 10 -type f ! -name "RecentFiles.*" ! -name ".RecentFiles.*" -amin 0.1 -ls | head -5 | egrep -v "athinio|proc" > /athinio/system/AccessFileUser
fi
#cat /FA1H /AccessFile /AccessFileUser | head -6 | uniq > /fileaccess
cat /athinio/system/AccessFile /athinio/system/AccessFileUser | head -5 | uniq > /athinio/system/fileaccess
awk '{print $NF}' /athinio/system/fileaccess > /athinio/system/FILEACCESS
if [[ ! -z $(grep '[^[:space:]]' /athinio/system/FILEACCESS) ]]; then
echo -e "LISTING FIVE ACCESSED FILES.." > /athinio/system/FA1H
fi

#rm -rf /fileaccess
find /* -maxdepth 10 -type f \( ! -iname AccessFile ! -iname AccessFileUser ! -iname ModifiedFile ! -iname ModifiedFileUser ! -iname ChangedFile ! -iname ChangedFileUser ! -iname LASTFIVEFILES.log ! -iname RecentFiles ! -iname LASTONEHOUR.log ! -iname LASTONEDAY.log ! -iname LASTEIGHTHOUR.log ! -iname FA1H ! -iname FM1H ! -iname FC1H ! -iname FileACCESS ! -iname fileMODIFIED ! -iname fileCHANGED \) -mmin 0.1 -ls | head -5 | egrep -v "athinio|proc" > /athinio/system/ModifiedFile
if [[ $USERNAME == root ]]; then
find /$USERNAME/* -maxdepth 10 -type f ! -name "RecentFiles.*" ! -name ".RecentFiles.*" -mmin 0.1  -ls | head -5 | egrep -v "athinio|proc" > /athinio/system/ModifiedFileUser
else
find /home/$USERNAME/* -maxdepth 10 -type f ! -name "RecentFiles.*" ! -name ".RecentFiles.*" -mmin 0.1  -ls | head -5 | egrep -v "athinio|proc" > /athinio/system/ModifiedFileUser
fi
#cat /FM1H /ModifiedFile /ModifiedFileUser | head -5 | uniq > /fileMODIFIED
cat /athinio/system/ModifiedFile /athinio/system/ModifiedFileUser | head -5 | uniq > /athinio/system/filemodified
awk '{print $NF}' /athinio/system/filemodified > /athinio/system/FILEMODIFIED
if [[ ! -z $(grep '[^[:space:]]' /athinio/system/FILEMODIFIED) ]]; then
echo -e "LISTING FIVE MODIFIED FILES.." > /athinio/system/FM1H
fi


find /* -maxdepth 10 -type f \( ! -iname AccessFile ! -iname AccessFileUser ! -iname ModifiedFile ! -iname ModifiedFileUser ! -iname ChangedFile ! -iname ChangedFileUser ! -iname LASTFIVEFILES.log ! -iname RecentFiles ! -iname LASTONEHOUR.log ! -iname LASTONEDAY.log ! -iname LASTEIGHTHOUR.log ! -iname FA1H ! -iname FM1H ! -iname FC1H ! -iname FileACCESS ! -iname fileMODIFIED ! -iname fileCHANGED \) -cmin 0.1 -ls | head -5 | egrep -v "athinio|proc" > /athinio/system/ChangedFile
if [[ $USERNAME == root ]]; then
find /$USERNAME/* -maxdepth 10 -type f ! -name "RecentFiles.*" ! -name ".RecentFiles.*" -cmin 0.1  -ls | head -5 | egrep -v "athinio|proc" > /athinio/system/ChangedFileUser
else
find /home/$USERNAME/* -maxdepth 10 -type f ! -name "RecentFiles.*" ! -name ".RecentFiles.*" -cmin 0.1  -ls | head -5 | egrep -v "athinio|proc" > /athinio/system/ChangedFileUser
fi
#cat /FC1H /ChangedFile /ChangedFileUser | head -6 | uniq > /fileCHANGED
cat /athinio/system/ChangedFile /athinio/system/ChangedFileUser | head -5 | uniq > /athinio/system/filechanged
awk '{print $NF}' /athinio/system/filechanged > /athinio/system/FILECHANGED
if [[ ! -z $(grep '[^[:space:]]' /athinio/system/FILECHANGED) ]]; then
echo -e "LISTING FIVE CHANGED FILES.." > /athinio/system/FC1H
fi

#cat /FileACCESS /fileMODIFIED /fileCHANGED | uniq > /LASTONEHOUR.log
cat /athinio/system/FA1H /athinio/system/FILEACCESS /athinio/system/FM1H /athinio/system/FILEMODIFIED /athinio/system/FC1H  /athinio/system/FILECHANGED | uniq > /athinio/system/LASTFIVEFILES.log
#[ -s /athinio/system/LASTFIVEFILES.log ]
#chkEmp=$?
#if [ $chkEmp == 1 ]
if [[ -z $(grep '[^[:space:]]' /athinio/system/LASTFIVEFILES.log) ]]; then
        echo "THERE IS NO LAST RECENT 5 ACCESSED FILES.."
else
echo ""
echo "`date +"%b %d %T %Y"` : INFO : Recent 5 files command executed" >> /var/log/osstatus.log
echo -e "LISTING RECENT 5 ACCESSED FILES..\n"
cat /athinio/system/LASTFIVEFILES.log
echo ""
fi

echo "Removing all files which all are created..!"
rm -rf /athinio/system/FA1H
rm -rf /athinio/system/AccessFile
rm -rf /athinio/system/AccessFileUser
rm -rf /athinio/system/fileaccess
rm -rf /athinio/system/FILEACCESS
rm -rf /athinio/system/FM1H
rm -rf /athinio/system/ModifiedFile
rm -rf /athinio/system/ModifiedFileUser
rm -rf /athinio/system/filemodified
rm -rf /athinio/system/FILEMODIFIED
rm -rf /athinio/system/FC1H
rm -rf /athinio/system/ChangedFile
rm -rf /athinio/system/ChangedFileUser
rm -rf /athinio/system/filechanged
rm -rf /athinio/system/FILECHANGED

fi
####	

if [ $1 == "-c" ]
then
echo "`date +"%b %d %T %Y"` : INFO : Last 8 Hr Recent files command invoked" >> /var/log/osstatus.log

find /* -maxdepth 10 -type f \( ! -iname AccessFile ! -iname AccessFileUser ! -iname ModifiedFile ! -iname ModifiedFileUser ! -iname ChangedFile ! -iname ChangedFileUser ! -iname LASTFIVEFILES.log ! -iname RecentFiles ! -iname LASTONEHOUR.log ! -iname LASTONEDAY.log ! -iname LASTEIGHTHOUR.log ! -iname FA1H ! -iname FM1H ! -iname FC1H ! -iname FileACCESS ! -iname fileMODIFIED ! -iname fileCHANGED \) -amin -480 -ls | head -5 | egrep -v "athinio|proc" > /athinio/system/AccessFile
if [[ $USERNAME == root ]]; then
find /$USERNAME/* -maxdepth 10 -type f ! -name "RecentFiles.*" ! -name ".RecentFiles.*" -amin -480 -ls | head -5 | egrep -v "athinio|proc" > /athinio/system/AccessFileUser
else
find /home/$USERNAME/* -maxdepth 10 -type f ! -name "RecentFiles.*" ! -name ".RecentFiles.*" -amin -480 -ls | head -5 | egrep -v "athinio|proc" > /athinio/system/AccessFileUser
fi
#cat /FA1H /AccessFile /AccessFileUser | head -6 | uniq > /fileaccess
cat /athinio/system/AccessFile /athinio/system/AccessFileUser | head -5 | uniq > /athinio/system/fileaccess
awk '{print $NF}' /athinio/system/fileaccess > /athinio/system/FILEACCESS
if [[ ! -z $(grep '[^[:space:]]' /athinio/system/FILEACCESS) ]]; then
echo -e "FILE ACCESSED BETWEEN LAST 8 HOUR.." > /athinio/system/FA1H
fi

#rm -rf /fileaccess
find /* -maxdepth 10 -type f \( ! -iname AccessFile ! -iname AccessFileUser ! -iname ModifiedFile ! -iname ModifiedFileUser ! -iname ChangedFile ! -iname ChangedFileUser ! -iname LASTFIVEFILES.log ! -iname RecentFiles ! -iname LASTONEHOUR.log ! -iname LASTONEDAY.log ! -iname LASTEIGHTHOUR.log ! -iname FA1H ! -iname FM1H ! -iname FC1H ! -iname FileACCESS ! -iname fileMODIFIED ! -iname fileCHANGED \) -mmin -480 -ls | head -5 | egrep -v "athinio|proc" > /athinio/system/ModifiedFile
if [[ $USERNAME == root ]]; then
find /$USERNAME/* -maxdepth 10 -type f ! -name "RecentFiles.*" ! -name ".RecentFiles.*" -mmin -480  -ls | head -5 | egrep -v "athinio|proc" > /athinio/system/ModifiedFileUser
else
find /home/$USERNAME/* -maxdepth 10 -type f ! -name "RecentFiles.*" ! -name ".RecentFiles.*" -mmin -480  -ls | head -5 | egrep -v "athinio|proc" > /athinio/system/ModifiedFileUser
fi
#cat /FM1H /ModifiedFile /ModifiedFileUser | head -5 | uniq > /fileMODIFIED
cat /athinio/system/ModifiedFile /athinio/system/ModifiedFileUser | head -5 | uniq > /athinio/system/filemodified
awk '{print $NF}' /athinio/system/filemodified > /athinio/system/FILEMODIFIED
if [[ ! -z $(grep '[^[:space:]]' /athinio/system/FILEMODIFIED) ]]; then
echo -e "FILE MODIFIED BETWEEN LAST 8 HOUR.." > /athinio/system/FM1H
fi

find /* -maxdepth 10 -type f \( ! -iname AccessFile ! -iname AccessFileUser ! -iname ModifiedFile ! -iname ModifiedFileUser ! -iname ChangedFile ! -iname ChangedFileUser ! -iname LASTFIVEFILES.log ! -iname RecentFiles ! -iname LASTONEHOUR.log ! -iname LASTONEDAY.log ! -iname LASTEIGHTHOUR.log ! -iname FA1H ! -iname FM1H ! -iname FC1H ! -iname FileACCESS ! -iname fileMODIFIED ! -iname fileCHANGED \) -cmin -480 -ls | head -5 | egrep -v "athinio|proc" > /athinio/system/ChangedFile
if [[ $USERNAME == root ]]; then
find /$USERNAME/* -maxdepth 10 -type f ! -name "RecentFiles.*" ! -name ".RecentFiles.*" -cmin -480  -ls | head -5 | egrep -v "athinio|proc" > /athinio/system/ChangedFileUser
else
find /home/$USERNAME/* -maxdepth 10 -type f ! -name "RecentFiles.*" ! -name ".RecentFiles.*" -cmin -480  -ls | head -5 | egrep -v "athinio|proc" > /athinio/system/ChangedFileUser
fi
#cat /FC1H /ChangedFile /ChangedFileUser | head -6 | uniq > /fileCHANGED
cat /athinio/system/ChangedFile /athinio/system/ChangedFileUser | head -5 | uniq > /athinio/system/filechanged
awk '{print $NF}' /athinio/system/filechanged > /athinio/system/FILECHANGED
if [[ ! -z $(grep '[^[:space:]]' /athinio/system/FILECHANGED) ]]; then
echo -e "FILE CHANGED BETWEEN LAST 8 HOUR.." > /athinio/system/FC1H
fi

#cat /FileACCESS /fileMODIFIED /fileCHANGED | uniq > /LASTONEHOUR.log
#cat /athinio/system/FileACCESS /athinio/system/fileMODIFIED /athinio/system/fileCHANGED | head -8 | uniq > /athinio/system/LASTEIGHTHOUR.log
cat /athinio/system/FA1H /athinio/system/FILEACCESS /athinio/system/FM1H /athinio/system/FILEMODIFIED /athinio/system/FC1H  /athinio/system/FILECHANGED | uniq > /athinio/system/LASTEIGHTHOUR.log

#[ -s /athinio/system/LASTEIGHTHOUR.log ]
#chkEmp=$?
#if [ $chkEmp == 1 ]
if [[ -z $(grep '[^[:space:]]' /athinio/system/LASTEIGHTHOUR.log) ]]; then
        echo "THERE IS NO FILE ACCESSED IN LAST EIGHT HOURS.."
else
echo ""
echo "`date +"%b %d %T %Y"` : INFO : Last 8 Hr Recent files command executed" >> /var/log/osstatus.log
echo -e "FILE ACCESSED IN LAST EIGHT HOURS..\n"
cat /athinio/system/LASTEIGHTHOUR.log
echo ""
fi

echo "Removing all files which all are created..!"
rm -rf /athinio/system/FA1H
rm -rf /athinio/system/AccessFile
rm -rf /athinio/system/AccessFileUser
rm -rf /athinio/system/fileaccess
rm -rf /athinio/system/FILEACCESS
rm -rf /athinio/system/FM1H
rm -rf /athinio/system/ModifiedFile
rm -rf /athinio/system/ModifiedFileUser
rm -rf /athinio/system/filemodified
rm -rf /athinio/system/FILEMODIFIED
rm -rf /athinio/system/FC1H
rm -rf /athinio/system/ChangedFile
rm -rf /athinio/system/ChangedFileUser
rm -rf /athinio/system/filechanged
rm -rf /athinio/system/FILECHANGED

fi

#####

if [ $1 == "-d" ]
then
echo "`date +"%b %d %T %Y"` : INFO : Last 1 Day Recent files command invoked" >> /var/log/osstatus.log

find /* -maxdepth 10 -type f \( ! -iname AccessFile ! -iname AccessFileUser ! -iname ModifiedFile ! -iname ModifiedFileUser ! -iname ChangedFile ! -iname ChangedFileUser ! -iname LASTFIVEFILES.log ! -iname RecentFiles ! -iname LASTONEHOUR.log ! -iname LASTONEDAY.log ! -iname LASTEIGHTHOUR.log ! -iname FA1H ! -iname FM1H ! -iname FC1H ! -iname FileACCESS ! -iname fileMODIFIED ! -iname fileCHANGED \) -atime -1 -ls | head -5 | egrep -v "athinio|proc" > /athinio/system/AccessFile
if [[ $USERNAME == root ]]; then
find /$USERNAME/* -maxdepth 10 -type f ! -name "RecentFiles.*" ! -name ".RecentFiles.*" -atime -1 -ls | head -5 | egrep -v "athinio|proc" > /athinio/system/AccessFileUser
else
find /home/$USERNAME/* -maxdepth 10 -type f ! -name "RecentFiles.*" ! -name ".RecentFiles.*" -atime -1 -ls | head -5 | egrep -v "athinio|proc" > /athinio/system/AccessFileUser
fi
#cat /FA1H /AccessFile /AccessFileUser | head -6 | uniq > /fileaccess
cat /athinio/system/AccessFile /athinio/system/AccessFileUser | head -5 | uniq > /athinio/system/fileaccess
awk '{print $NF}' /athinio/system/fileaccess > /athinio/system/FILEACCESS

if [[ ! -z $(grep '[^[:space:]]' /athinio/system/FILEACCESS) ]]; then
echo -e "FILE ACCESSED BETWEEN LAST 1 DAY.." > /athinio/system/FA1H
fi
#rm -rf /fileaccess

find /* -maxdepth 10 -type f \( ! -iname AccessFile ! -iname AccessFileUser ! -iname ModifiedFile ! -iname ModifiedFileUser ! -iname ChangedFile ! -iname ChangedFileUser ! -iname LASTFIVEFILES.log ! -iname RecentFiles ! -iname LASTONEHOUR.log ! -iname LASTONEDAY.log ! -iname LASTEIGHTHOUR.log ! -iname FA1H ! -iname FM1H ! -iname FC1H ! -iname FileACCESS ! -iname fileMODIFIED ! -iname fileCHANGED \) -mtime -1 -ls | head -5 | egrep -v "athinio|proc" > /athinio/system/ModifiedFile
if [[ $USERNAME == root ]]; then
find /$USERNAME/* -maxdepth 10 -type f ! -name "RecentFiles.*" ! -name ".RecentFiles.*" -mtime -1  -ls | head -5 | egrep -v "athinio|proc" > /athinio/system/ModifiedFileUser
else
find /home/$USERNAME/* -maxdepth 10 -type f ! -name "RecentFiles.*" ! -name ".RecentFiles.*" -mtime -1  -ls | head -5 | egrep -v "athinio|proc" > /athinio/system/ModifiedFileUser
fi
#cat /FM1H /ModifiedFile /ModifiedFileUser | head -5 | uniq > /fileMODIFIED
cat /athinio/system/ModifiedFile /athinio/system/ModifiedFileUser | head -5 | uniq > /athinio/system/filemodified
awk '{print $NF}' /athinio/system/filemodified > /athinio/system/FILEMODIFIED

if [[ ! -z $(grep '[^[:space:]]' /athinio/system/FILEMODIFIED) ]]; then
echo -e "FILE MODIFIED BETWEEN LAST 1 DAY.." > /athinio/system/FM1H
fi

find /* -maxdepth 10 -type f \( ! -iname AccessFile ! -iname AccessFileUser ! -iname ModifiedFile ! -iname ModifiedFileUser ! -iname ChangedFile ! -iname ChangedFileUser ! -iname LASTFIVEFILES.log ! -iname RecentFiles ! -iname LASTONEHOUR.log ! -iname LASTONEDAY.log ! -iname LASTEIGHTHOUR.log ! -iname FA1H ! -iname FM1H ! -iname FC1H ! -iname FileACCESS ! -iname fileMODIFIED ! -iname fileCHANGED \) -ctime -1 -ls | head -5 | egrep -v "athinio|proc" > /athinio/system/ChangedFile
if [[ $USERNAME == root ]]; then
find /$USERNAME/* -maxdepth 10 -type f ! -name "RecentFiles.*" ! -name ".RecentFiles.*" -ctime -1  -ls | head -5 | egrep -v "athinio|proc" > /athinio/system/ChangedFileUser
else
find /home/$USERNAME/* -maxdepth 10 -type f ! -name "RecentFiles.*" ! -name ".RecentFiles.*" -ctime -1  -ls | head -5 | egrep -v "athinio|proc" > /athinio/system/ChangedFileUser
fi
#cat /FC1H /ChangedFile /ChangedFileUser | head -6 | uniq > /fileCHANGED
cat /athinio/system/ChangedFile /athinio/system/ChangedFileUser | head -5 | uniq > /athinio/system/filechanged
awk '{print $NF}' /athinio/system/filechanged > /athinio/system/FILECHANGED

if [[ ! -z $(grep '[^[:space:]]' /athinio/system/FILECHANGED) ]]; then
echo -e "FILE CHANGED BETWEEN LAST 1 DAY.." > /athinio/system/FC1H
fi

#cat /FileACCESS /fileMODIFIED /fileCHANGED | uniq > /LASTONEHOUR.log
#cat /FileACCESS /fileMODIFIED /fileCHANGED | head -8 | uniq > /LASTONEDAY.log

cat /athinio/system/FA1H /athinio/system/FILEACCESS /athinio/system/FM1H /athinio/system/FILEMODIFIED /athinio/system/FC1H  /athinio/system/FILECHANGED | uniq > /athinio/system/LASTONEDAY.log
#[ -s /athinio/system/LASTONEDAY.log ]
#chkEmp=$?
#if [ $chkEmp == 1 ]
if [[ -z $(grep '[^[:space:]]' /athinio/system/LASTONEDAY.log) ]]; then
        echo "THERE IS NO FILE ACCESSED IN LAST ONE DAY.."
else
echo ""
echo "`date +"%b %d %T %Y"` : INFO : Last 1 Day Recent files command executed" >> /var/log/osstatus.log
echo -e "FILE ACCESSED IN LAST ONE DAY..\n"
cat /athinio/system/LASTONEDAY.log
echo ""
fi

echo "Removing all files which all are created..!"
rm -rf /athinio/system/FA1H
rm -rf /athinio/system/AccessFile
rm -rf /athinio/system/AccessFileUser
rm -rf /athinio/system/fileaccess
rm -rf /athinio/system/FILEACCESS
rm -rf /athinio/system/FM1H
rm -rf /athinio/system/ModifiedFile
rm -rf /athinio/system/ModifiedFileUser
rm -rf /athinio/system/filemodified
rm -rf /athinio/system/FILEMODIFIED
rm -rf /athinio/system/FC1H
rm -rf /athinio/system/ChangedFile
rm -rf /athinio/system/ChangedFileUser
rm -rf /athinio/system/filechanged
rm -rf /athinio/system/FILECHANGED

fi
