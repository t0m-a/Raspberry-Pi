# Raspberry Pi Scripts

A collection of Bash and Python tools for Raspberry Pi, Pi managed Arduinos and IoT Cloud Services.

## Python scripts

* Wia.io Python scripts: enable Raspberry Pi to request data from Arduino(s) over USB serial or
Bluetooth serial connexions and send them to wia.io cloud and messaging service.
* MongoDB Python script(s): commit data retreived through serial connexions to a Mongo database service.

## Bash shellscripts

* Debian post-install script for Raspberry Pi and AWS EC2 cloud instances including Docker installation.
* rpiCloudBackup: backup Raspberry Pi folder into cloud storage services using Rclone
* rpiNetBiosScanHostsUpdate: I wrote this script before I had a DNS server to handle a cluster of RPIs.
Basically you will need NBTSCAN installed and SMB Client to resolve name based on Netbios. A kind of
home made "bonjour" service.
