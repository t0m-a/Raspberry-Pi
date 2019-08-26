#!/usr/bin/env bash

# Script to update an A DNS record with IP address using Gandi LiveDNS API.
# Using only standard UNIX tools, but if you have jq installed, you can use it.
# Automate with cron, TTL set to 1200 seconds...
# Author: Thomas Simon
# Date: 2019/08/26

# Variables update accordingly:
APIKEY="API_KEY"
DOMAIN="example.com"
SUBDOMAIN="subdomain.example.com"
DATE=$(date)

# Getting current ISP IP address:
CURRENT_IP=$(wget -O - -q https://api.ipify.org/)

# Getting the current IP address in DNS record with awk and sed:
RECORD_IP=$(wget -O - -q --header "X-Api-Key: $APIKEY" https://dns.api.gandi.net/api/v5/domains/tsimon.me/$DOMAIN/$SUBDOMAIN/A | awk -F':' '{print $7}' | \
sed 's/\[//;s/\"//;s/\"//;s/\]//;s/\}//;s/^[ \t]*//')

# Getting the Domain zone link for update with awk and sed:
ZONE_HREF=$(curl -s -H "X-Api-Key: $APIKEY" https://dns.api.gandi.net/api/v5/domains/$DOMAIN | awk -F',' '{print $6}' | \
sed 's/".*"://;s/\"//;s/\"//;s/^[ \t]*//')
# Uncomment if you prefer to use jq JSON parser
#ZONE_HREF=$(curl -s -H "X-Api-Key: $APIKEY" https://dns.api.gandi.net/api/v5/domains/$DOMAIN | jq -r '.zone_records_href')

# Checking if IP address has changed and logging result
if [ "$CURRENT_IP" == "$RECORD_IP" ]
	then
		echo -e "$DATE : Record unchanged" >> logs.log
	else
		curl -D- -X PUT -H "Content-Type: application/json" \
        	-H "X-Api-Key: $APIKEY" \
        	-d "{\"rrset_name\": \"$SUBDOMAIN\",
             	\"rrset_type\": \"A\",
             	\"rrset_ttl\": 1200,
             	\"rrset_values\": [\"$CURRENT_IP\"]}" \
        	$ZONE_HREF/$SUBDOMAIN/A &&

		echo -e "$DATE : IP updated" > logs.log
fi
exit
