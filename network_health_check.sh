#!/bin/bash

REPORT_FILE="network_report.txt"

echo "====================================" | tee $REPORT_FILE
echo "     NETWORK HEALTH CHECK REPORT    " | tee -a $REPORT_FILE
echo "====================================" | tee -a $REPORT_FILE

# Server Information
echo "" | tee -a $REPORT_FILE
echo "1. SERVER INFORMATION" | tee -a $REPORT_FILE
echo "Hostname      : $(hostname)" | tee -a $REPORT_FILE
echo "Current User  : $(whoami)" | tee -a $REPORT_FILE
echo "Date & Time   : $(date)" | tee -a $REPORT_FILE

# Network Information
echo "" | tee -a $REPORT_FILE
echo "2. NETWORK INFORMATION" | tee -a $REPORT_FILE

IP_ADDRESS=$(hostname -I | awk '{print $1}')
DEFAULT_GATEWAY=$(ip route | grep default | awk '{print $3}')
DNS_SERVER=$(grep "nameserver" /etc/resolv.conf | awk '{print $2}' | head -1)

echo "IP Address      : $IP_ADDRESS" | tee -a $REPORT_FILE
echo "Default Gateway : $DEFAULT_GATEWAY" | tee -a $REPORT_FILE
echo "DNS Server      : $DNS_SERVER" | tee -a $REPORT_FILE

# Internet Connectivity
echo "" | tee -a $REPORT_FILE
echo "3. INTERNET CONNECTIVITY" | tee -a $REPORT_FILE

if ping -c 4 8.8.8.8 > /dev/null 2>&1
then
    echo "Internet Connectivity : UP" | tee -a $REPORT_FILE
else
    echo "Internet Connectivity : DOWN" | tee -a $REPORT_FILE
fi

# DNS Resolution
echo "" | tee -a $REPORT_FILE
echo "4. DNS RESOLUTION" | tee -a $REPORT_FILE

if nslookup google.com > /dev/null 2>&1
then
    echo "DNS Resolution : WORKING" | tee -a $REPORT_FILE
else
    echo "DNS Resolution : FAILED" | tee -a $REPORT_FILE
fi

# Website Availability
echo "" | tee -a $REPORT_FILE
echo "5. WEBSITE AVAILABILITY" | tee -a $REPORT_FILE

websites=("google.com" "github.com" "amazon.com")

for site in "${websites[@]}"
do
    if ping -c 2 $site > /dev/null 2>&1
    then
        echo "$site : UP" | tee -a $REPORT_FILE
    else
        echo "$site : DOWN" | tee -a $REPORT_FILE
    fi
done

echo "" | tee -a $REPORT_FILE
echo "Report saved to $REPORT_FILE" | tee -a $REPORT_FILE