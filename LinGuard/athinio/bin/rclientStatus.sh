#!/bin/bash

check=$(ps -elf | grep -i /rationalVault/bin/rclient | wc -l)
echo $check

if [ $check -le 1 ]
then
	echo restarting rclient
	service rclient restart
fi
