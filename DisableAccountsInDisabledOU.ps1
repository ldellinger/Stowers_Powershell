Get-ADUser -Filter * -SearchBase "OU=Disabled Accounts,DC=stowerscat,DC=com" | Disable-ADAccount
Get-ADComputer -Filter * -SearchBase "OU=Computers,OU=Disabled Accounts,DC=stowerscat,DC=com" | Disable-ADAccount
