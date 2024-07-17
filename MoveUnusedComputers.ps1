#Move Computers that haven't been logged into for more than 90days
$DaysInactive = 90
$time = (Get-Date).Adddays(-($DaysInactive))
$ComputerList = Get-ADComputer -Filter {LastLogonTimeStamp -lt $time}
foreach ($Computer in $ComputerList) {
        Move-ADObject $Computer.distinguishedname  -TargetPath "OU=Computers,OU=Disabled Accounts,DC=stowerscat,DC=com" -verbose
     }
