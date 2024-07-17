Connect-ExchangeOnline -UserPrincipalName ldellinger@stowerscat.com -ShowProgress $true
# Get all users
New-DynamicDistributionGroup -Name 'All West Knoxville Employees' -RecipientFilter "StreetAddress -eq '10644 Lexington Drive'"
