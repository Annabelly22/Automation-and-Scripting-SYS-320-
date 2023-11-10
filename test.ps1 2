# Function to retrieve running processes and paths
Function Get-RunningProcesses {
    return Get-Process | Select-Object Name, Path
}

# Function to retrieve registered services and paths
Function Get-RegisteredServices {
    return Get-WmiObject -Query "SELECT * FROM Win32_Service" | Select-Object Name, PathName
}

# Function to retrieve TCP network sockets
Function Get-TCPSockets {
    return Get-NetTCPConnection | Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort
}

# Function to retrieve user account information
Function Get-UserAccountInfo {
    return Get-WmiObject -Query "SELECT * FROM Win32_UserAccount" | Select-Object Name, Domain, SID
}

# Function to retrieve network adapter configuration information
Function Get-NetworkAdapterConfig {
    return Get-WmiObject -Query "SELECT * FROM Win32_NetworkAdapterConfiguration" | Select-Object IPAddress, DefaultIPGateway, DNSServerSearchOrder
}

# Function to execute additional cmdlets
Function Execute-AdditionalCmdlets {
    # Additional cmdlet 1
    # Your explanation here

    # Additional cmdlet 2
    # Your explanation here

    # Additional cmdlet 3
    # Your explanation here

    # Additional cmdlet 4
    # Your explanation here
}

# Prompt the user for the location to save the results
$saveLocation = Read-Host "Enter the directory to save the results"

# Create a directory for results
New-Item -ItemType Directory -Path $saveLocation

# Call the functions to gather information
Get-RunningProcesses | Export-Csv -Path "$saveLocation\runningProcesses.csv" -NoTypeInformation
Get-RegisteredServices | Export-Csv -Path "$saveLocation\registeredServices.csv" -NoTypeInformation
Get-TCPSockets | Export-Csv -Path "$saveLocation\tcpSockets.csv" -NoTypeInformation
Get-UserAccountInfo | Export-Csv -Path "$saveLocation\userAccountInfo.csv" -NoTypeInformation
Get-NetworkAdapterConfig | Export-Csv -Path "$saveLocation\networkAdapterConfig.csv" -NoTypeInformation
Execute-AdditionalCmdlets

# Create file hashes for CSV files
$csvFiles = Get-ChildItem -Path $saveLocation -Filter *.csv
ForEach ($csvFile in $csvFiles) {
    $hash = Get-FileHash -Path $csvFile.FullName -Algorithm SHA256
    $hash | Out-File -FilePath "$saveLocation\$($hash.Hash) $($csvFile.Name).txt"
}

# Specify the destination path for the zip file
$zipDestination = Join-Path -Path $saveLocation -ChildPath "results.zip"

# Zip the results
Write-Output "Zipping the results..."
Compress-Archive -Path $saveLocation -DestinationPath $zipDestination
Read-Host "Press Enter to continue..."

# Create a checksum of the zipped file
Write-Output "Creating a checksum of the zipped file..."
$zipChecksum = Get-FileHash -Path $zipDestination -Algorithm SHA256
$zipChecksum | Out-File -FilePath "$saveLocation\$($zipChecksum.Hash) results.zip.txt"
Read-Host "Press Enter to continue..."