$timespan = New-Timespan –Days 90
Search-ADAccount –UsersOnly –AccountInactive –TimeSpan $timespan