# Replace with your actual username
$remoteUsername = "username"    

# Replace with your actual host
$remoteHost = "remote-ssh.com" 

# Default SSH port
$remotePort = 22 

# Replace with your actual password
$remotePassword = "password" 

# clear the screen
Clear-Host

# create credentials object
$credential = (New-Object System.Management.Automation.PSCredential($remoteUsername, (ConvertTo-SecureString -String $remotePassword -AsPlainText -Force)))

# Establish SSH session
$session = New-SSHSession -ComputerName $remoteHost -Credential $credential -Port $remotePort

# Function to display help information
function Show-Help {
    Write-Host "Available Windows Commands:"
    Write-Host "  exit       - Quit the script"
    Write-Host "  clear      - Clear the screen"
    Write-Host "  send       - Send a file to the server"
    Write-Host "  download   - Download a file from the server"
    Write-Host "  help       - Show this help message"
}

# Check if the session was established successfully
if ($session) {
    Write-Host "Connected to $remoteHost"

    try {
        # Infinite loop for user input
        while ($true) {
            # Ask for input
            $inputCommand = Read-Host "Enter command (type 'exit' to quit, 'help' for command list):"

            # Exit the loop if the user enters 'exit'
            if ($inputCommand -eq 'exit') {
                break
            }
            if ($inputCommand -eq '') {
                continue
            }

            # Check for the 'clear' command
            if ($inputCommand -eq 'clear') {
                Clear-Host
                continue
            }

            # Check for the 'send' command
            if ($inputCommand -eq 'send') {
                # Prompt user for local and remote file paths
                $localFilePath = Read-Host "Enter local file path:"
                $remoteFilePath = Read-Host "Enter remote file path:"

                # Send the file to the server using scp
                Set-SCPItem -ComputerName "$remoteHost" -Path "$localFilePath" -Credential $credential  -Port "$remotePort" -Destination "$remoteFilePath"

                Write-Host "File sent successfully."
                continue
            }

            # Check for the 'download' command
            if ($inputCommand -eq 'download') {
                # Prompt user for remote and local file paths
                $remoteFilePath = Read-Host "Enter remote file path:"
                $localFilePath = Read-Host "Enter local file path:"

                # Download the file from the server using scp
                Get-SCPItem -PathType File -ComputerName $remoteHost -Port $remotePort -Credential $credential -Path $remoteFilePath -Destination $localFilePath
                Write-Host "File downloaded successfully."
                continue
            }

            # Check for the 'help' command
            if ($inputCommand -eq 'help') {
                Show-Help
                continue
            }

            # Invoke the SSH command
            $output = Invoke-SSHCommand -SessionId $session.SessionId -Command $inputCommand

            # Display the output
            $output.Output
        }
    }
    catch {
        Write-Host "Error: $_"
    }
    finally {
        # Close the SSH session
        Remove-SSHSession -SessionId $session.SessionId
        Write-Host "Disconnected from $remoteHost"
    }
}
else {
    Write-Host "Failed to connect to $remoteHost"
}
