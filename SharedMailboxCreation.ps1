# Import the CSV file
$mailboxData = Import-Csv -Path "C:\Users\smc0329\Downloads\SharedMailboxes.csv"

# Connect to Exchange Online
Connect-ExchangeOnline -UserPrincipalName ldellinger@stowerscat.com

# Iterate through each row in the CSV file
foreach ($mailbox in $mailboxData) {
    $displayName = $mailbox.DisplayName
    $emailAddress = $mailbox.Email
    $alias = $emailAddress.Split('@')[0]

    # Create the shared mailbox
    New-Mailbox -Shared -Name $displayName -DisplayName $displayName -PrimarySmtpAddress $emailAddress
}