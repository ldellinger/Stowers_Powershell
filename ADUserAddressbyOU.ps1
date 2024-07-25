Import-Module ActiveDirectory

# Define a function to update user attributes
function Update-UserAttributes {
    param (
        [string]$OU,
        [string]$StreetAddress,
        [string]$City,
        [string]$State,
        [string]$PostalCode,
        [string]$Country,
        [string]$OfficeName
    )

    Get-ADUser -Filter * -SearchBase $OU | ForEach-Object {
        Set-ADUser -Identity $_ -StreetAddress $StreetAddress -City $City -State $State -PostalCode $PostalCode -Country $Country -Replace @{physicalDeliveryOfficeName=$OfficeName}
        Write-Output "Updated user: $($_.SamAccountName) in $OfficeName"
    }
}

# Update attributes for each OU
Update-UserAttributes -OU "OU=East Knoxville,OU=AppStoreDisabled,DC=stowerscat,DC=com" -StreetAddress "6301 Old Rutledge Pike" -City "Knoxville" -State "TN" -PostalCode "37924" -Country "US" -OfficeName "East Knoxville"
Update-UserAttributes -OU "OU=Chattanooga,OU=AppStoreDisabled,DC=stowerscat,DC=com" -StreetAddress "4066 South Access Road" -City "Chattanooga" -State "TN" -PostalCode "37406" -Country "US" -OfficeName "Chattanooga"
Update-UserAttributes -OU "OU=Crossville,OU=AppStoreDisabled,DC=stowerscat,DC=com" -StreetAddress "215 Interchange Drive" -City "Crossville" -State "TN" -PostalCode "38571" -Country "US" -OfficeName "Crossville"
Update-UserAttributes -OU "OU=Sevierville,OU=AppStoreDisabled,DC=stowerscat,DC=com" -StreetAddress "1825 Veterans Boulevard" -City "Sevierville" -State "TN" -PostalCode "37862" -Country "US" -OfficeName "Sevierville"
Update-UserAttributes -OU "OU=Kingsport,OU=AppStoreDisabled,DC=stowerscat,DC=com" -StreetAddress "9960 Airport Parkway" -City "Kingsport" -State "TN" -PostalCode "37663" -Country "US" -OfficeName "Kingsport"
Update-UserAttributes -OU "OU=West Knoxville,OU=AppStoreDisabled,DC=stowerscat,DC=com" -StreetAddress "10644 Lexington Drive" -City "Knoxville" -State "TN" -PostalCode "37932" -Country "US" -OfficeName "West Knoxville"
