# Install AzureAD Module
# This line is commented out; ensure the module is installed before running or run this line manually if needed.
# Install-Module AzureAD -Force -AllowClobber

# Connect to AzureAD
Connect-AzureAD

$csvPath = "C:\Users\smc0329\My Drive\New365UserAccounts.xlsx"
$CSVrecords = Import-Csv -Path $csvPath -Delimiter ","

$SkippedUsers = @()
$FailedUsers = @()

foreach ($CSVrecord in $CSVrecords) {
    $upn = $CSVrecord.userPrincipalName
    $user = Get-AzureADUser -Filter "userPrincipalName eq '$upn'"

    if ($user) {
        try {
            # Update items based on CSV, skipping blank or empty values
            if ($CSVrecord.Department) { $user | Set-AzureADUser -Department $CSVrecord.Department }
            if ($CSVrecord.jobTitle) { $user | Set-AzureADUser -JobTitle $CSVrecord.jobTitle }
            if ($CSVrecord.streetAddress) { $user | Set-AzureADUser -StreetAddress $CSVrecord.streetAddress }
            # Add similar conditions for other attributes

            $user | Set-AzureADUser -CompanyName "Stowers Machinery Corporation"
            # Add other attributes not checked for blank values
        } catch {
            $FailedUsers += $upn
            Write-Warning "$upn user found, but FAILED to update. Error: $($_.Exception.Message)"
        }
    } else {
        Write-Warning "$upn not found, skipped"
        $SkippedUsers += $upn
    }
}

# Output results for skipped and failed users
Write-Output "Skipped Users: " $SkippedUsers
Write-Output "Failed to Update Users: " $FailedUsers