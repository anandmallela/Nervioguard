#!/usr/bin/expect -f

spawn twadmin -m P /etc/tripwire/twpol.txt
expect "Please enter your site passphrase: "
send -- "\r"
expect EOF
