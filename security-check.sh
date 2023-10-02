#!/bin/bash

# Check function
checks() {
    local desc=$1
    local expected=$2
    local actual=$3
    local remediation=$4

    if [[ "$expected" != "$actual" ]]; then
        echo "Not compliant. The $desc value should be: $expected but the current value is: $actual."
        echo -e "Remediation\n$remediation\n"
    fi
}

# Check IP forwarding
ip_forward_chk=$(sysctl net.ipv4.ip_forward | awk '{print $NF}')
checks "IP forwarding" "0" "$ip_forward_chk" "Edit /etc/sysctl.conf and set:\nnet.ipv4.ip_forward=1\nto\nnet.ipv4.ip_forward=0.\nThen run: sysctl -w"

# Check ICMP redirects
icmp_redirects_chk=$(sysctl net.ipv4.conf.all.accept_redirects | awk '{print $NF}')
checks "ICMP redirects" "0" "$icmp_redirects_chk" "Edit /etc/sysctl.conf and set:\nnet.ipv4.conf.all.accept_redirects=0\nThen run: sysctl -w"

# Check for permissions
perm_check() {
    local file=$1
    local perm=$2
    stat -c %a "$file" | grep -q "$perm" || {
        echo "Incorrect permissions on $file"
        echo "Remediation: chmod $perm $file"
    }
}

perm_check "/etc/crontab" "600"
perm_check "/etc/cron.hourly" "700"
perm_check "/etc/cron.daily" "700"
perm_check "/etc/cron.weekly" "700"
perm_check "/etc/cron.monthly" "700"
perm_check "/etc/passwd" "644"
perm_check "/etc/shadow" "640"
perm_check "/etc/group" "644"
perm_check "/etc/gshadow" "640"
perm_check "/etc/passwd-" "644"
perm_check "/etc/shadow-" "640"
perm_check "/etc/group-" "644"
perm_check "/etc/gshadow-" "640"

# Check for legacy '+' entries
grep -qE '^\+' /etc/passwd && echo "Legacy '+' entries found in /etc/passwd. Remediation: Remove them."
grep -qE '^\+' /etc/shadow && echo "Legacy '+' entries found in /etc/shadow. Remediation: Remove them."
grep -qE '^\+' /etc/group && echo "Legacy '+' entries found in /etc/group. Remediation: Remove them."

# Check for UID 0 root account
if [[ $(awk -F: '($3 == "0") {print $1}' /etc/passwd | grep -v root | wc -l) -ne 0 ]]; then
    echo "There are other accounts than root with UID 0."
    echo "Remediation: Ensure root is the only UID 0 account."
fi
