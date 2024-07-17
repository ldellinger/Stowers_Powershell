# Import the Active Directory module
Import-Module ActiveDirectory

# Define the threshold date for inactivity (90 days ago)
$InactiveDays = 90
$ThresholdDate = (Get-Date).AddDays(-$InactiveDays)

# Define the source and target OUs
$SourceOUs = @(
    "OU=USERS, OU=CHATTANOOGA, OU=APPSTOREDISABLED,DC=STOWERSCAT,DC=COM",
    "OU=USERS, OU=CROSSVILLE, OU=APPSTOREDISABLED,DC=STOWERSCAT,DC=COM",
    "OU=USERS, OU=EAST KNOXVILLE, OU=APPSTOREDISABLED,DC=STOWERSCAT,DC=COM",
    "OU=USERS, OU=KINGSPORT, OU=APPSTOREDISABLED,DC=STOWERSCAT,DC=COM",
    "OU=USERS, OU=SEVIERVILLE, OU=APPSTOREDISABLED,DC=STOWERSCAT,DC=COM",
    "OU=USERS, OU=WEST KNOXVILLE, OU=APPSTOREDISABLED,DC=STOWERSCAT,DC=COM"
)

# Iterate through the source OUs to disable inactive users, then move them
foreach ($OU in $SourceOUs) {
    # Find and disable inactive users
    $InactiveUsers = Get-ADUser -SearchBase $OU -Filter {LastLogonDate -lt $ThresholdDate -and Enabled -eq $true} -Properties LastLogonDate
    foreach ($User in $InactiveUsers) {
        Disable-ADAccount -Identity $User
        Write-Host "Disabled $($User.Name) as it has been inactive for more than 90 days."
    }
}

# Move the disabled users to the "OU=DISABLED ACCOUNTS, DC=STOWERSCAT, DC=COM" OU
$DisabledUsers = Get-ADUser -SearchBase $OU -Filter {Enabled -eq $false} -Properties Enabled
foreach ($User in $DisabledUsers) {
    Move-ADObject -Identity $User.DistinguishedName -TargetPath "OU=DISABLED ACCOUNTS, DC=STOWERSCAT, DC=COM"
    Write-Host "Moved $($User.Name) to Disabled Accounts OU."
}

# Now, delete disabled users who have been inactive for more than 90 days
$DisabledUsersToDelete = Get-ADUser -SearchBase "OU=DISABLED ACCOUNTS, DC=STOWERSCAT, DC=COM" -Filter {Enabled -eq $false -and WhenChanged -lt $ThresholdDate}
foreach ($UserToDelete in $DisabledUsersToDelete) {
    Remove-ADUser -Identity $UserToDelete -Confirm:$false
    Write-Host "Deleted $($UserToDelete.Name) as it was disabled for more than 90 days."
}

# Append log messages to the newly created log file
$LogMessages | Out-File -FilePath \\d39dc1.stowerscat.com\c$\Scripts\DisabledUserLog.txt -Append