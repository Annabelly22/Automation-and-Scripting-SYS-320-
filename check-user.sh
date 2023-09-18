.sh
#!/bin/bash

SERVER_CONFIG="wg0.conf"

# Check if wg0.conf exists
if [ ! -f "$SERVER_CONFIG" ]; then
    echo "File $SERVER_CONFIG does not exist. Please create the configuration file first."
    exit 1
fi

# Function to check if a user exists in wg0.conf
check_user_existence() {
    read -p "Enter the username to check: " username
    if grep -q "AllowedIPs = 10.0.0.$username/32" "$SERVER_CONFIG"; then
        echo "User $username exists in $SERVER_CONFIG."
    else
        echo "User $username does not exist in $SERVER_CONFIG."
    fi
}

# Main menu
PS3="Select an option: "

options=("Check if a user exists in $SERVER_CONFIG" 
         "Quit")

select opt in "${options[@]}"
do
    case $opt in
        "Check if a user exists in $SERVER_CONFIG")
            check_user_existence
            ;;
        "Quit")
            break
            ;;
        *) echo "Invalid option";;
    esac
done
