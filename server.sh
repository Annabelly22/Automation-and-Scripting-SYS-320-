# cat server.sh
#!/bin/bash

SERVER_CONFIG="wg0.conf"

# Check if wg0.conf exists
if [ -f "$SERVER_CONFIG" ]; then
    read -p "File $SERVER_CONFIG exists. Do you want to overwrite it? (yes/no) " response

    if [ "$response" != "yes" ]; then
        echo "Exiting program."
        exit 1
    fi
fi

# Create/overwrite the server configuration file
echo "Creating new server configuration file..."
# (Replace the line below with actual server configuration generation)
echo "[Interface]" > $SERVER_CONFIG
echo "Address = 10.0.0.1/24" >> $SERVER_CONFIG
echo "ListenPort = 51820" >> $SERVER_CONFIG
echo "PrivateKey = iMbARfLiZEibZotDOXPZ0lvadUjsN3C59BKfgMtV2Wg=" >> $SERVER_CONFIG
echo "SaveConfig = true" >> $SERVER_CONFIG

