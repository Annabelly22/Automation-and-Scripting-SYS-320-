# Ask the user what they want to do
$choice = Read-Host "Please select an option:
1. Start the Windows Calculator
2. Stop the Windows Calculator
3. Export process information to a CSV file

Enter the corresponding number (1, 2, or 3):"

# Check the user's choice
if ($choice -eq "1") {
    Write-Host "Starting the Windows Calculator..."
    Start-Process calc.exe -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 1  # Wait for a moment
    $calculatorProcess = Get-Process -Name CalculatorApp -ErrorAction SilentlyContinue
    if ($null -ne $calculatorProcess) {
        Write-Host "The Windows Calculator has been started successfully."
    }
    else {
        Write-Host "Failed to start the Windows Calculator."
    }
}
elseif ($choice -eq "2") {
    Write-Host "Stopping the Windows Calculator..."
    $calculatorProcess = Get-Process -Name CalculatorApp -ErrorAction SilentlyContinue
    if ($null -ne $calculatorProcess) {
        Stop-Process -Name CalculatorApp
        Start-Sleep -Seconds 1  # Wait for a moment
        Write-Host "The Windows Calculator has been closed."
    }
    else {
        Write-Host "The Windows Calculator is not currently running."
    }
}
elseif ($choice -eq "3") {
    Write-Host "Exporting information about running processes and services..."
    Start-Sleep -Seconds 1  # Wait for a moment
    
    # Get information about running processes
    $processes = Get-Process | Select-Object Id, Name, CPU, Description, Path

    # Get information about running services
    $services = Get-Service | Select-Object DisplayName, Status, StartType, ServiceType

    # Prepare a CSV file to store the data
    $csvFile = "ProcessAndServicesInfo.csv"

    # Combine process and service data into a single array
    $data = $processes + $services

    # Export the combined data to a CSV file
    $data | Export-Csv -Path $csvFile -NoTypeInformation

    Write-Host "Data has been exported to $csvFile"
}
else {
    Write-Host "Invalid choice. Please enter 1, 2, or 3 to select one of the options."
}
