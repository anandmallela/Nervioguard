#!/bin/bash

outfile=/rcheckOut1
outfile1=/rcheckOutput
src="/rationalVault/all_xml_dir/store"
des="/rationalVault/all_xml_dir/store1"
if [ -f "$outfile" ]; then
	echo "file exist"
	rm -rf /rcheckOut1
fi
if [ -f "$outfile1" ]; then
        echo "file exist"
        rm -rf /rcheckOutput
fi
srcN=`find $src -type f | wc -l`

echo $srcN

refN=`find $des -type f | wc -l`

echo $refN
if [ $srcN == $refN ];then
	echo "No new files found"
echo "`date +"%b %d %T %Y"` : INFO : No new files Found in $src"  >> /var/log/osstatus.log
	for i in `find $src -type f`
	do
		newfile=$(basename $i)
		#echo $newfile
		#echo $newfile >> /athinio/system/rcheckOutput
		#echo $i

		j=`find $des -type f -name $newfile`
		#oldFile=$(basename $j)
		#echo $oldFile
		#echo $j
		
		echo "executing rChecker"
                       echo "`date +"%b %d %T %Y"` : INFO : executing rChecker for $i" >> /var/log/osstatus.log
		/athinio/bin/rChecker $i $j >> /rcheckOut1
		
	done


else
	echo "New files found" > /rcheckOut1
        echo "Ransomware corruption FOund" >> /rcheckOut1
echo "`date +"%b %d %T %Y"` : ATTACK-R : Ransomeware corruption Found in dir $src" >> /var/log/osstatus.log
fi

j=1

if [ $j == 1 ];
then

if grep -q "Ransomware corruption FOund" "/rcheckOut1"; then
 echo "Ransomware corruption FOund" > /rcheckOutput
echo "`date +"%b %d %T %Y"` : ATTACK-R : Ransomeware corruption Found in $src" >> /var/log/osstatus.log

# echo "Alert:Ransomware corruption FOund" >> /athinio/system/alertlog.txt
 sed -i "s/\(<Ransom_current_status>\)[^<]*\(<\/Ransom_current_status>\)/\11\2/" /athinio/system/alertlog.xml
  echo "hai"
elif grep -q "Ransomware corruption NOT FOund" "/rcheckOut1"; then
  echo "Ransomware corruption NOT FOund" > /rcheckOutput
echo "`date +"%b %d %T %Y"`: INFO-R : Ransomware corruption NOT Found in $src" >> /var/log/osstatus.log
  sed -i "s/\(<Ransom_current_status>\)[^<]*\(<\/Ransom_current_status>\)/\10\2/" /athinio/system/alertlog.xml
  echo "hello"
else
  echo "Usage rChecker newFile oldFileFileSizes are too small for ransomTests. Must be above 1024 Bytes in size" > /rcheckOutput
echo "`date +"%b %d %T %Y"`: INFO-R : PATH : $src Usage rChecker newFile oldFileFileSizes are too small for ransomTests. Must be above 1024 Bytes in size" >> /var/log/osstatus.log
  sed -i "s/\(<Ransom_current_status>\)[^<]*\(<\/Ransom_current_status>\)/\10\2/" /athinio/system/alertlog.xml
  echo "hru"
fi

fi


echo "`date +"%b %d %T %Y"`:  AUDIT_LOGGING : Executed Ransomware-checker"  >> /rationalVault/log/rationalclient.log
echo "`date +"%b %d %T %Y"`:  INFO : Executed Ransomware-checker for $src"  >> /var/log/osstatus.log
