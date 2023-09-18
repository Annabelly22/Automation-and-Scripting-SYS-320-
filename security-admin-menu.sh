#!/bin/bash

PS3="Select a security admin task: "

options=("List open network sockets" 
         "Check for non-root users with UID 0"
         "Show last 10 logged in users"
         "Show currently logged in users"
         "Quit")

select opt in "${options[@]}"
do
    case $opt in
        "List open network sockets")
            netstat -tuln
            ;;
        "Check for non-root users with UID 0")
            awk -F: '($3 == 0) {print}' /etc/passwd
            ;;
        "Show last 10 logged in users")
            last -n 10
            ;;
        "Show currently logged in users")
            who
            ;;
        "Quit")
            break
            ;;
        *) echo "Invalid option";;
    esac
done
