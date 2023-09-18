#!/bin/bash

SERVER_CONFIG="wg0.conf"

# Function to delete a user from wg0.conf
delete_user() {
    read -p "Enter the username to delete: " username
    if grep -q "AllowedIPs = 10.0.0.$username/32" "$SERVER_CONFIG"; then
        sed -i "/AllowedIPs = 10.0.0.$username\/32/d" "$SERVER_CONFIG"
        echo "User $username has been deleted from $SERVER_CONFIG."
    else
        echo "User $username does not exist in $SERVER_CONFIG."
    fi
}

# Main menu
PS3="Select an option: "

options=("Delete a user from $SERVER_CONFIG" 
         "Quit")

select opt in "${options[@]}"
do
    case $opt in
        "Delete a user from $SERVER_CONFIG")
            delete_user
            ;;
        "Quit")
            break
            ;;
        *) echo "Invalid option";;
    esac
done
