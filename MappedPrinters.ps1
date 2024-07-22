function Get-MappedDrives($ComputerName){
  $Report = @() 
  #Ping remote machine, continue if available
  if(Test-Connection -ComputerName $computername -Count 1 -Quiet){
    #Get remote explorer session to identify current user
    $explorer = Get-WmiObject -ComputerName $computername -Class win32_process | ?{$_.name -eq "explorer.exe"}
    
    #If a session was returned check HKEY_USERS for Network drives under their SID
    if($explorer){
      $Hive = [long]$HIVE_HKU = 2147483651
      $sid = ($explorer.GetOwnerSid()).sid
      $owner  = $explorer.GetOwner()
      $RegProv = get-WmiObject -List -Namespace "root\default" -ComputerName $computername | Where-Object {$_.Name -eq "StdRegProv"}
      $DriveList = $RegProv.EnumKey($Hive, "$($sid)\Network")
      
      #If the SID network has mapped drives iterate and report on said drives
      if($DriveList.sNames.count -gt 0){
        $Person = "$($owner.Domain)\$($owner.user)"
        foreach($drive in $DriveList.sNames){
	  $hash = [ordered]@{
	    ComputerName	= $ComputerName
	    User		= $Person
	    Drive		= $drive
	    Share		= "$(($RegProv.GetStringValue($Hive, "$($sid)\Network\$($drive)", "RemotePath")).sValue)"
	  }
	    # Add the hash to a new object
	  $objDriveInfo = new-object PSObject -Property $hash
	    # Store our new object within the report array
	  $Report += $objDriveInfo
        }
      }else{
	  $hash = [ordered]@{
	    ComputerName	= $ComputerName
	    User		= $Person
	    Drive		= ""
	    Share		= "No mapped drives"
	  }
	  $objDriveInfo = new-object PSObject -Property $hash
	  $Report += $objDriveInfo
      }
    }else{
	$hash = [ordered]@{
	  ComputerName	= $ComputerName
	  User		= "Nobody"
	  Drive		= ""
	  Share		= "explorer not running"
	}
	$objDriveInfo = new-object PSObject -Property $hash
	$Report += $objDriveInfo
      }
  }else{
      $hash = [ordered]@{
	ComputerName	= $ComputerName
	User		= "Nobody"
	Drive		= ""
	Share		= "Cannot connect"
      }
      $objDriveInfo = new-object PSObject -Property $hash
      $Report += $objDriveInfo
  }
  return $Report
}

$computername = Get-Content 'C:\Users\smc0329\Desktop\names.Txt'
$CSVpath = "C:\Users\smc0329\Desktop\Maps.csv"
$CSVReport = @() 

remove-item $CSVpath 

foreach ($computer in $computername) {
	Write-host $computer 
	$CSVReport += Get-MappedDrives($computer)
}

# Export our report array to CSV and store as our dynamic file name
$CSVReport | Export-Csv -NoTypeInformation -Path $CSVpath