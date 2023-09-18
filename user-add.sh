#!/bin/bash

# Prompt the user for the username to add
read -p "Enter the username to add: " username

# Add the user with the specified shell
sudo useradd -m -s /home/aotutu/Automation-and-Scripting-SYS-320-/security-admin-menu.sh "$username"

# Prompt the user if they want to check if the user was added
read -p "Do you want to check if the user was added? (yes/no): " response

if [ "$response" == "yes" ]; then
    # Check if the user exists
    if id "$username" &>/dev/null; then
        echo "User $username has been successfully added."
    else
        echo "User $username was not added."
    fi
fi
