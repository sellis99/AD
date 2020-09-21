# get computers in Americas
Get-ADComputer -Filter * -SearchBase "OU=Americas,OU=Workstations,DC=domain,DC=COM" | select Name > c:\temp\machines.csv

# get servers sorted by name
Get-ADComputer -filter {(enabled -eq "true") -and (operatingsystem -like "windows server*")} -properties name, operatingsystem, ipv4address | select-object name, operatingsystem, ipv4address | sort name | ft

# get the users in the new OU. Added this group to Track-It import
Get-ADUser -filter 'Name -like "steve*"' -searchbase "OU=New Users,OU=Americas,DC=domain,DC=com" | select name, distinguishedname

# get all Surface accounts and pw date
Get-ADComputer -Filter 'Name -like "Surface*"' -Properties passwordlastset | sort-object passwordlastset | ft name, passwordlastset -AutoSize

# get all enabled user accounts sorted by password last set date
Get-ADUser -filter 'enabled -eq $true' -SearchBase "OU=Users,DC=ad,DC=domain,DC=com" -properties passwordlastset | select name, samaccountname, passwordlastset | sort passwordlastset | export-csv -NoTypeInformation c:\temp\userlist.csv

# get profile paths that match a particular TS
Get-ADUser -filter {profilepath -like "*hou1*"} -searchbase "OU=Users,DC=domain,DC=com" -properties name, profilepath | ft

# get password last set date for user
Get-ADUser -identity user -properties passwordlastset | select name, samaccountname, passwordlastset

# get TS Profile path for all users in domain
$Users = ([ADSISearcher]"(&(objectCategory=person)(objectClass=user)(!userAccountControl:1.2.840.113556.1.4.803:=2))").findall() | select path
foreach ($user in $users) {
 $userSearch = [adsi]"$($user.path)"
 try
 {
   #$userSearch.psbase.InvokeGet(“displayname”)  
   $userSearch.psbase.InvokeGet(“terminalservicesprofilepath”)
 }
 Catch
 {}
 }

# Get all Hyper-V VMs
 Get-ADObject –LDAPFilter "(&(objectClass=serviceConnectionPoint)(CN=Windows Virtual Machine))"
 
# Groups a user belongs to
Get-ADPrincipalGroupMembership user | select name | sort name

# Get currently logged in user - works with pssession
Get-WMIObject -class Win32_ComputerSystem | select username

# Get last 10 app errors in log
Get-EventLog -LogName Application -source "Application Error" -newest 10

# Get computer serial #
gwmi win32_bios | fl SerialNumber

# get status of a user
Get-ADUser -filter 'samaccountName -like "user"' -searchbase "OU=Users,DC=domain,DC=com" | select samaccountname, name, enabled

# read list of users and create csv with their account status (enabled/disabled)
$users = gc C:\temp\userdirs.txt
foreach ($userdir in $users) {Get-ADUser -filter "samaccountName -eq '$userdir'" -searchbase "OU=Users,DC=domain,DC=com" | select samaccountname, enabled, name | Export-Csv 'c:\temp\userdirs.csv' -append}

