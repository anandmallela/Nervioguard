#!/usr/bin/expect -f

spawn "sh -c 'tripwire --init'"
expect "Please enter your local passphrase: "
#{ send "\r" }
send -- "\r"
#expect "### Continuing..."
#send -- "sleep 20"
expect EOF

