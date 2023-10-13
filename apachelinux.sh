#!/bin/bash

# Prompt user for Apache log file
read -p "Please enter an apache log file: " logFile

# Check if the file exists
if [[ ! -f ${logFile} ]]
then
    echo "File doesn't exist."
    exit 1
fi

# Extract IPs, sort them, and remove duplicates
ipAddresses=$(awk '{print $1}' "${logFile}" | sort | uniq)

# Iterate over IP addresses and add an IPTables rule for each
for ip in ${ipAddresses}
do
    # Check if IP address is valid
    if [[ ${ip} =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]
    then
        # Add IPTables rule
        iptables -A INPUT -s ${ip} -j DROP
        echo "Blocked IP: ${ip}"
    fi
done
