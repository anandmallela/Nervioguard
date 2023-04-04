#!/bin/bash

rm -rf /rcheckOutput
rm -rf /rcheckOut1
cp -rf /athinio/bin/rchecker1.sh /

cd /

chmod 755 rchecker1.sh

bash rchecker1.sh 

rm -rf /rchecker1.sh

