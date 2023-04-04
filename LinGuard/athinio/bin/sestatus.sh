#!/bin/bash/

##SELINUX STATUS......######
oldVal=$(awk -F "[><]" '/selinuxStatus/{print $3}' /athinio/system/cmd_out.xml | cut -d " " -f 9)
rebootChk=$(awk -F "[><]" '/selinuxStatus/{print $3}' /athinio/system/cmd_out.xml | cut -d " " -f 13)
newVal=`getenforce`

echo $oldVal $rebootChk $newVal

if [[ $oldVal == $newVal ]] && [[ $rebootChk != reboot ]]; then
echo "Status Already updated"

elif [[ $newVal == Disabled ]] && [[ $rebootChk == reboot ]] ; then
echo "Reboot Status Already updated"

else
if [[ $newVal == Enforcing ]]; then 
sed -i "s/\(<selinuxStatus>\)[^<]*\(<\/selinuxStatus>\)/\1ALERT: SELinux at Enforcing mode.\2/" /athinio/system/cmd_out.xml

elif [[ $newVal == Permissive ]]; then
sed -i "s/\(<selinuxStatus>\)[^<]*\(<\/selinuxStatus>\)/\1INFO: SELinux at Permissive mode.\2/" /athinio/system/cmd_out.xml

elif [[ $newVal == Disabled ]]; then
sed -i "s/\(<selinuxStatus>\)[^<]*\(<\/selinuxStatus>\)/\1INFO: SELinux Disabled.\2/" /athinio/system/cmd_out.xml
fi

fi
