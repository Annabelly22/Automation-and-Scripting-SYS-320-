$choice = 0

while ($choice -ne 4) {
    Clear-Host
    Write-Host "Service List Options:"
    Write-Host "1. List all services"
    Write-Host "2. List stopped services"
    Write-Host "3. List running services"
    Write-Host "4. Quit"

    $choice = Read-Host "Enter the number of your choice"

    if ($choice -eq 1) {
        Write-Host "Listing all services..."
        Get-Service | Select-Object DisplayName, Status | Format-Table -AutoSize
        Read-Host "Press Enter to continue..."
    } elseif ($choice -eq 2) {
        Write-Host "Listing stopped services..."
        Get-Service | Where-Object { $_.Status -eq "Stopped" } | Select-Object DisplayName, Status | Format-Table -AutoSize
        Read-Host "Press Enter to continue..."
    } elseif ($choice -eq 3) {
        Write-Host "Listing running services..."
        Get-Service | Where-Object { $_.Status -eq "Running" } | Select-Object DisplayName, Status | Format-Table -AutoSize
        Read-Host "Press Enter to continue..."
    } elseif ($choice -eq 4) {
        Write-Host "Exiting the script."
    } else {
        Write-Host "Invalid input. Please enter a valid option (1, 2, 3, or 4)."
        Read-Host "Press Enter to continue..."
    }
}
