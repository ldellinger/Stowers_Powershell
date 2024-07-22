$name= Read-Host -Prompt "Enter userid"
Get-ADUser $Name -Properties carLicense
Read-Host -Prompt "Press Enter key to continue..."
