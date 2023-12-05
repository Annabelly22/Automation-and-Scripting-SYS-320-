# Array of URLs containing threat intelligence data
$drop_urls = @("https://rules.emergingthreats.net/blockrules/emerging-botcc.rules", "https://rules.emergingthreats.net/blockrules/compromised-ips.txt")

# Array to store downloaded file names
$input_files = @();

# File to store bad IPs in iptables format
$bad_ips = "bad_ips.txt"

# Loop through each URL in $drop_urls
foreach ($url in $drop_urls) {
    # Extract the file name from the URL
    $file_name = $url.Split('/')[-1]

    # Check if the file does not exist, then download it
    if (!(Test-Path $file_name)) {
        Invoke-WebRequest -Uri $url -OutFile $file_name
    }

    # Add file to the input_files array
    $input_files += $file_name
}

# Regular expression to extract IP addresses from files
$regex = "\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b"

# Use Select-String to find IP addresses in the input_files
Select-String -Path $input_files -Pattern $regex | 
    ForEach-Object { $_.Matches } | 
    ForEach-Object { $_.Value } | 
    Sort-Object -Unique | 
    Out-File -FilePath $bad_ips

# Read content from bad_ips.txt and format it for iptables
(Get-Content -Path $bad_ips) | 
    ForEach-Object { $_ -replace "^", "iptables -A INPUT -s " -replace "$", " -J DROP" } | 
    Out-File -FilePath "iptables.sh"
