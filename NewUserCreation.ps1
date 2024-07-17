#Find-Module -Name MSOnline | Install-Module -Force 

#Enter Credentials for 365
$MSOnlineCred = Get-Credential

#Connect to 365
Connect-MsolService -Credential $MSOnlineCred

# Prompt user for input
$firstName = Read-Host "Enter first name"
$lastName = Read-Host "Enter last name"
$Usertitle = Read-Host "Enter job title"
$userdepartment = Read-Host "Enter department:"
$location = Read-Host "Enter location code (00 for EK, 01 for Chatt, 02 for Kingsport, 03 for Crossville, 04 for WK, 05 for Sevierville):"
$officeNumber = Read-Host "Enter office phone number:"
$mobileNumber = Read-Host "Enter mobile phone number:"
$licenseOption = Read-Host "Select license option (00 for No License, 01 for F3, 02 for E5):"

# Determine the physical delivery office name, street address, city, state, and zip based on location
switch ($location) {
    "00" {
        $physicalDeliveryOfficeName = "East Knoxville"
        $streetAddress = "6301 Old Rutledge Pike"
        $city = "Knoxville"
        $state = "TN"
        $zip = "37924"
    }
    "01" {
        $physicalDeliveryOfficeName = "Chattanooga"
        $streetAddress = "4066 South Access Road"
        $city = "Chattanooga"
        $state = "TN"
        $zip = "37406"
    }
    "02" {
        $physicalDeliveryOfficeName = "Tri-Cities"
        $streetAddress = "9960 Airport Parkway"
        $city = "Kingsport"
        $state = "TN"
        $zip = "37663"
    }
    "03" {
        $physicalDeliveryOfficeName = "Crossville"
        $streetAddress = "215 Interchange Drive"
        $city = "Crossville"
        $state = "TN"
        $zip = "38571"
    }
    "04" {
        $physicalDeliveryOfficeName = "West Knoxville"
        $streetAddress = "10644 Lexington Drive"
        $city = "Knoxville"
        $state = "TN"
        $zip = "37932"
    }
    "05" {
        $physicalDeliveryOfficeName = "Sevierville"
        $streetAddress = "1825 Veterans Boulevard"
        $city = "Sevierville"
        $state = "TN"
        $zip = "37865"
    }
    Default {
        Write-Host "Invalid location code. Exiting script."
        Exit
    }
}

# Determine the License
switch ($licenseOption) {
    "00" {
        $UserLicense = "$null"
    }
    "01" {
        $UserLicense = "SPE_F1"
    }
    "02" {
        $UserLicense = "SPE_E5"
    }
    Default {
        Write-Host "Invalid license code. Exiting script."
        Exit
    }
}

# Determine the username
$username = $firstName.Substring(0,1) + $lastName

# Set company name
$companyName = "Stowers Machinery Corporation"

# Create the new user
New-MsolUser -UserPrincipalName "$username@stowerscat.com" `
    -DisplayName "$firstName $lastName" `
    -FirstName $firstName `
    -LastName $lastName `
    -City $city `
    -State $state `
    -Country "United States" `
    -PostalCode $zip `
    -StreetAddress $streetAddress `
    -PhoneNumber $officeNumber `
    -MobilePhone $mobileNumber `
    -Department $userdepartment `
    -Title $Usertitle `
#    -LicenseAssignment $UserLicense