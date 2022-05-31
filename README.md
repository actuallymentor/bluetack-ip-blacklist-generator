# Bluetack ip blocklist project

This simple script grabs the Bluetack ip blacklist and adds routes to disable connections to these ip addresses. This is useful for commercial webhost and vpn servers.

The ubuntu-block-blacklist.sh script adds rules to your routing table.

The ubuntu-generate-list.sh creates a file called 'blacklist' with all the rules in there.

The 'blasklist' file in this repo can be added to programs like Transmission as a blocklist.