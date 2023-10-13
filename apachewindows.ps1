# Prompt user for Apache log file
$logFile = Read-Host -Prompt "Please enter an apache log file"

# Check if the file exists
if (-Not (Test-Path -Path $logFile -PathType Leaf))
{
    Write-Host "File doesn't exist."
    exit
}

# Extract IPs, sort them, and remove duplicates
$ipAddresses = Get-Content -Path $logFile | % { ($_ -split ' ')[0] } | Sort-Object | Get-Unique

# Iterate over IP addresses and add a Windows Firewall rule for each
foreach ($ip in $ipAddresses)
{
    # Check if IP address is valid
    if ($ip -match "^\d{1,3}(\.\d{1,3}){3}$")
    {
        # Add Windows Firewall rule
        netsh advfirewall firewall add rule name="BLOCK IP ADDRESS - $ip" dir=in action=block remoteip=$ip
        Write-Host "Blocked IP: $ip"
    }
}
