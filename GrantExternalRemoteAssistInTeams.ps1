# Import the module and connect to Teams
Import-Module MicrosoftTeams
$credential = Get-Credential
Connect-MicrosoftTeams -Credential $credential

# Update the global policy to allow external users to request control
#Set-CsTeamsMeetingPolicy -Identity "Global" -AllowExternalParticipantGiveRequestControl $true

# Optional: Create and assign a new policy
 #New-CsTeamsMeetingPolicy -Identity "ExternalUserControlPolicy" -AllowExternalParticipantGiveRequestControl $true
 Grant-CsTeamsMeetingPolicy -Identity "ldellinger@stowerscat.com" -PolicyName "ExternalUserControlPolicy"

# Verify the settings
Get-CsTeamsMeetingPolicy -Identity "ExternalUserControlPolicy"
# Get-CsOnlineUser -Identity "user@domain.com" | Select DisplayName, TeamsMeetingPolicy