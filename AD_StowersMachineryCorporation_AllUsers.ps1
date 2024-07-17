Import-Module ActiveDirectory
$company = "Stowers Machinery Corporation"

Get-ADUser -Filter * -Properties company | ForEach-Object {
    Set-ADUser -Identity $_ -Company $company
}