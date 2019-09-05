#!/bin/bash
# /etc/hosts updater script v0.7
# This script uses Steve Friedl's Netbios Network Scanner.
# If you don't have it installed, you may want to apt-get install nbtscan or download it at:
# http://www.unixwiz.net/tools/nbtscan.html
# Thanks to Steve's work, it is available for Linux distros as well as for Windows OS.
# Not originaly intended to work on Windows, it will however work in Cygwin, BASH for Windows 10 and Babun shells.
# This script needs to be run with elevated priviledges as root or aministrator user

# Defining variables
# Setting the working directory
workdir='/var/tmp'
# Input the host actual name you are running this script on
thishostname='insert_your_actual_hostname'
# Input your local network IP range. IE: 10.0.0.1-10
network='insert_your_network_range'
# Input your network's gateway IP address and hostname
gateway='insert_your_gateway_IP_and_hostname'

# Checking root priviledges
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Checking for proper variables information
if [ "$thishostname" = 'insert_your_actual_hostname' ]
  then echo "This is the first time you are running this script. Please edit the file with your current hostname"; exit 1
else

if [ "$network" = 'insert_your_network_range' ]
  then echo "This is the first time you are running this script. Please edit the file with your network range."; exit 1
else

if [ "$gateway" = 'insert_your_gateway_IP_and_hostname' ]
  then echo "This is the first time you are running this script. Please edit the file with your gateway IP address and hostname."; exit 1
else

# Backing up original content of the hosts file
echo "127.0.0.1 $thishostname localhost
::1 localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
" > $workdir/hosts.orig

# Scanning the network then updating the hosts file
cd $workdir
echo
echo "Scanning the network..."
nbtscan -q -e $network > scanlog.txt
echo $gateway >> $workdir/scanlog.txt;
echo "" > /etc/hosts;
cat $workdir/hosts.orig > /etc/hosts;
cat $workdir/scanlog.txt >> /etc/hosts;
echo "Done! Added nodes are shown below."
cat $workdir/scanlog.txt
rm $workdir/scanlog.txt
rm $workdir/hosts.orig
fi
fi
fi
exit 0
##EOF 
	
