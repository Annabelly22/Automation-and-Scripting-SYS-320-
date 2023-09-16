#!/bin/bash

SERVER_CONFIG="wg0.conf"
PEER_CONFIG="peer.conf"
PEER_NUM=1

# Generate peer private and public keys
PEER_PRIVATE_KEY=$(wg genkey)
PEER_PUBLIC_KEY=$(echo $PEER_PRIVATE_KEY | wg pubkey)

# Define the VPN IP for the peer
PEER_IP="10.0.0.$((PEER_NUM + 1))/32"

# Append the peer configuration to the server's wg0.conf
echo "[Peer]" >> $SERVER_CONFIG
echo "PublicKey = $PEER_PUBLIC_KEY" >> $SERVER_CONFIG
echo "AllowedIPs = $PEER_IP" >> $SERVER_CONFIG

# Create the peer's configuration file
echo "[Interface]" > $PEER_CONFIG
echo "Address = $PEER_IP" >> $PEER_CONFIG
echo "PrivateKey = $PEER_PRIVATE_KEY" >> $PEER_CONFIG
echo "# Connect to the server" >> $PEER_CONFIG
echo "[Peer]" >> $PEER_CONFIG
echo "PublicKey = QR8slB8F+0GPD6gacWBRNicM6WhCwJhE1b2uDWfhh3o=" # Replace this with the server's public key
echo "Endpoint = 69.5.115.98:51820" # Replace SERVER_IP with your server's public IP
echo "AllowedIPs = 0.0.0.0/0" >> $PEER_CONFIG # Or the IPs/ranges you want to route through the VPN

# Refresh the WireGuard interface without disrupting active connections
wg addconf wg0 <(wg-quick strip wg0)

# Copy the server config to the /etc/wireguard directory
sudo cp $SERVER_CONFIG /etc/wireguard/

echo "Peer configuration has been added and server configuration has been updated."
