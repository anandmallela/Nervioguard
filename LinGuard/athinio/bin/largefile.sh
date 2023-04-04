#!/bin/bash

largefilepath=$(awk -F "[><]" '/param0/{print $3}' /athinio/system/param_cmd_57.xml)
Asecpath=$(awk -F "[><]" '/param0/{print $3}' /athinio/system/param_cmd_58.xml)
Msecpath=$(awk -F "[><]" '/param0/{print $3}' /athinio/system/param_cmd_59.xml)

#echo "a=$largefilepath and b=$secpath"
>/athinio/system/LARGEFILES
>/athinio/system/ASECFILES
>/athinio/system/MSECFILES

#This is for Option -a
path="/var/neridio"

if [ ! -d $path ]
then
    mkdir -p $path
    chmod -R 0777 $path
fi

if [ $1 == "-a" ]
then
 echo "`date +"%b %d %T %Y"` : INFO : Get elephant files command invoked" >> /var/log/osstatus.log

 rm -rf /athinio/system/largefile_error.txt
 
 largefilepath=$(awk -F "[><]" '/param0/{print $3}' /athinio/system/param_cmd_57.xml)

if [ -e "$largefilepath" ]
then
    echo "Moving the files larger than 2GB and Unused for more than a year to /athinio/system/LARGEFILES..."
    find "$largefilepath" -type f -atime -24 -size +2k > /athinio/system/LARGEFILES
    Size=$(stat /athinio/system/LARGEFILES | grep Size | awk '/Size/ {print $2}')
    if [ $Size == 0 ]
    then
        echo "No Large Files Found..."
        exit 1
    else 
        #rm -rf /var/neridio/largefile.xml
        echo "Creating the list of files in /var/neridio/largefile.xml..."
        /athinio/bin/largefiles /athinio/system/LARGEFILES
        echo "`date +"%b %d %T %Y"` : SUCCESS : Get elephant files command executed" >> /var/log/osstatus.log
    fi
else
echo "`date +"%b %d %T %Y"` :  ALERT : Entered path \"$largefilepath\" not found for checking Elephant files" >> /var/log/osstatus.log
echo "`date +"%b %d %T %Y"` : ERROR : \"$largefilepath\" folder doesn't exists for get Elephant files. Please check the folder name..!" > /athinio/system/largefile_error.txt
echo "ERROR:\"$largefilepath\" folder doesn't exists for get Elephant files. Please check the folder name..!" > /athinio/system/alertlog1.txt

fi
fi

#This is for Option -b

if [ $1 == "-b" ]
then
 echo "`date +"%b %d %T %Y"` : INFO : Get accessed files command invoked" >> /var/log/osstatus.log
 
 rm -rf /athinio/system/accfile_error.txt
 
 Asecpath=$(awk -F "[><]" '/param0/{print $3}' /athinio/system/param_cmd_58.xml)

if [ -e "$Asecpath" ]
then
    echo "Moving the files that are accessed in last 24hrs.. to /SECFILES..."
    find "$Asecpath" -type f -atime -1 > /athinio/system/ASECFILES
    Size1=$(stat /athinio/system/ASECFILES | grep Size | awk '/Size/ {print $2}')
    #echo $Size1
    if [ $Size1 == 0 ]
    then
        echo "No Files Found..."
        exit 1  
    else

        #rm -rf /var/neridio/Asecfile.xml
        echo "Creating the list of files in /var/neridio/Asecfile.xml..."
        /athinio/bin/largefiles /athinio/system/ASECFILES
        echo "`date +"%b %d %T %Y"` : SUCCESS : Get accessed files command executed" >> /var/log/osstatus.log
    fi
else
echo "`date +"%b %d %T %Y"` :  ALERT : Entered path \"$Asecpath\" not found for checking Accessed  files" >> /var/log/osstatus.log
echo "`date +"%b %d %T %Y"` : ERROR : \"$Asecpath\" folder doesn't exists for get Accessed files. Please check the folder name..!" > /athinio/system/accfile_error.txt
echo "ERROR:\"$Asecpath\" folder doesn't exists for get Accessed files. Please check the folder name..!" > /athinio/system/alertlog1.txt
fi

fi
if [ $1 == "-c" ]
then
 echo "`date +"%b %d %T %Y"` : INFO : Get modified files command invoked" >> /var/log/osstatus.log
 
 rm -rf /athinio/system/modfile_error.txt 

 Msecpath=$(awk -F "[><]" '/param0/{print $3}' /athinio/system/param_cmd_59.xml)

if [ -e "$Msecpath" ]
then
    #rm -rf /var/neridio/Asecfile.xml
    echo "Moving the files that are Modified in last 24hrs.. to /SECFILES..."
    find "$Msecpath" -type f -mtime -1 > /athinio/system/MSECFILES
    Size1=$(stat /athinio/system/MSECFILES | grep Size | awk '/Size/ {print $2}')
    #echo $Size1
    if [ $Size1 == 0 ]
    then
        echo "No Files Found..."
        exit 1
    else

        #rm -rf /var/neridio/Msecfile.xml
        echo "Creating the list of files in /var/neridio/Msecfile.xml..."
        /athinio/bin/largefiles /athinio/system/MSECFILES
        echo "`date +"%b %d %T %Y"` : SUCCESS : Get modified files command executed" >> /var/log/osstatus.log
    fi
 else
echo "`date +"%b %d %T %Y"` :  ALERT : Entered path \"$Msecpath\" not found for checking Modified files" >> /var/log/osstatus.log
echo "`date +"%b %d %T %Y"` : ERROR : \"$Msecpath\" folder doesn't exists for get Modified files. Please check the folder name..!" > /athinio/system/modfile_error.txt
echo "ERROR:\"$Msecpath\" folder doesn't exists for get Modified files. Please check the folder name..!" > /athinio/system/alertlog1.txt
fi
fi
