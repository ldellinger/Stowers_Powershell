$groupname = Read-Host "Enter AD Group Name"
Get-ADGroupMember -Identity $groupname | Select-Object name