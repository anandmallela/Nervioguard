#!/usr/bin/expect -f

spawn tripwire-setup-keyfiles
expect "Please enter your site passphrase: "
#{ send "\r" }
send -- "\r"
expect "Please enter your site passphrase:"
send -- "\r"
expect EOF

