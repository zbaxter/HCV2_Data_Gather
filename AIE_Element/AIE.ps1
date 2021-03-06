##########################################################
###				AIE Health Check		 			   ###
##########################################################

function isNumeric ($x) {
    $x2 = 0
    $isNum = [System.Int32]::TryParse($x, [ref]$x2)
    return $isNum
}

function Json-SB($Property, $Value){
	$JsonSB = ""
	if(($Property -ne $null) -and ($Value -ne $null))
	{
		if($Property.Contains("Date") -or $Property.Contains("LastHeartbeat") -or  ($Property -eq "Timestamp") -or ($Property -eq "time") ) # Value meets this data time format 10/2/2015 10:56:24 PM
		{
			if($Property -eq "Timestamp") { $Property = "@timestamp" }
			$Value = $Value.ToString()
			if($Value -match "[0-9]+/[0-9]+/\d\d\d\d [0-9]+:[0-9]+:[0-9]+ AM")
			{
				$Year = ($Value.Split("/")[2] | % { $_ -split ' ' })[0]
				$MonthCharacters = ($Value.Split("/")[0]) | measure-object -character | select -expandproperty characters
				if($MonthCharacters -le 1) { $Month = "0" + ($Value.Split("/")[0]) }
				else { $Month = $Value.Split("/")[0] }
				$DayCharacters = ($Value.Split("/")[1]) | measure-object -character | select -expandproperty characters
				if($DayCharacters -le 1) { $Day = "0" + ($Value.Split("/")[1]) }
				else { $Day = $Value.Split("/")[1] }
				$Time = ($Value.Split("/")[2] | % { $_ -split ' ' })[1]
				$TimeHour = $Time.Split(":")[0]
				$HourCharacters = $TimeHour | measure-object -character | select -expandproperty characters
				if($HourCharacters -le 1) { $Hour = "0" + $TimeHour }
				else { $Hour = $TimeHour }
				$TimeMin = $Time.Split(":")[1]
				$MinCharacters = $TimeMin | measure-object -character | select -expandproperty characters
				if($MinCharacters -le 1) { $Min = "0" + $TimeMin }
				else { $Min = $TimeMin }
				$TimeSec = $Time.Split(":")[2]
				$SecCharacters = $TimeSec | measure-object -character | select -expandproperty characters
				if($SecCharacters -le 1) { $Sec = "0" + $TimeSec }
				else { $Sec = $TimeSec }
				$Value = $Year + "-" + $Day + "-" + $Month + "T" + $Hour + ":" + $Min + ":" + $Sec
			}
			elseif($Value -match "[0-9]+/[0-9]+/\d\d\d\d [0-9]+:[0-9]+:[0-9]+ PM") 
			{ 
				$Year = ($Value.Split("/")[2] | % { $_ -split ' ' })[0]
				$MonthCharacters = ($Value.Split("/")[0]) | measure-object -character | select -expandproperty characters
				if($MonthCharacters -le 1) { $Month = "0" + ($Value.Split("/")[0]) }
				else { $Month = $Value.Split("/")[0] }
				$DayCharacters = ($Value.Split("/")[1]) | measure-object -character | select -expandproperty characters
				if($DayCharacters -le 1) { $Day = "0" + ($Value.Split("/")[1]) }
				else { $Day = $Value.Split("/")[1] }
				$Time = ($Value.Split("/")[2] | % { $_ -split ' ' })[1]
				$TimeHour = ([int]::Parse($Time.Split(":")[0]) + 12).ToString()
				$HourCharacters = $TimeHour | measure-object -character | select -expandproperty characters
				if($HourCharacters -le 1) { $Hour = "0" + $TimeHour }
				else { $Hour = $TimeHour }
				$TimeMin = $Time.Split(":")[1]
				$MinCharacters = $TimeMin | measure-object -character | select -expandproperty characters
				if($MinCharacters -le 1) { $Min = "0" + $TimeMin }
				else { $Min = $TimeMin }
				$TimeSec = $Time.Split(":")[2]
				$SecCharacters = $TimeSec | measure-object -character | select -expandproperty characters
				if($SecCharacters -le 1) { $Sec = "0" + $TimeSec }
				else { $Sec = $TimeSec }
				$Value = $Year + "-" + $Day + "-" + $Month + "T" + $Hour + ":" + $Min + ":" + $Sec
			}
			elseif($Value -match "[0-9]+/[0-9]+/\d\d\d\d [0-9]+:[0-9]+:[0-9]+") 
			{ 
				$Year = ($Value.Split("/")[2] | % { $_ -split ' ' })[0]
				$MonthCharacters = ($Value.Split("/")[0]) | measure-object -character | select -expandproperty characters
				if($MonthCharacters -le 1) { $Month = "0" + ($Value.Split("/")[0]) }
				else { $Month = $Value.Split("/")[0] }
				$DayCharacters = ($Value.Split("/")[1]) | measure-object -character | select -expandproperty characters
				if($DayCharacters -le 1) { $Day = "0" + ($Value.Split("/")[1]) }
				else { $Day = $Value.Split("/")[1] }
				$Time = ($Value.Split("/")[2] | % { $_ -split ' ' })[1]
				$TimeHour = $Time.Split(":")[0]
				$HourCharacters = $TimeHour | measure-object -character | select -expandproperty characters
				if($HourCharacters -le 1) { $Hour = "0" + $TimeHour }
				else { $Hour = $TimeHour }
				$TimeMin = $Time.Split(":")[1]
				$MinCharacters = $TimeMin | measure-object -character | select -expandproperty characters
				if($MinCharacters -le 1) { $Min = "0" + $TimeMin }
				else { $Min = $TimeMin }
				$TimeSec = $Time.Split(":")[2]
				$SecCharacters = $TimeSec | measure-object -character | select -expandproperty characters
				if($SecCharacters -le 1) { $Sec = "0" + $TimeSec }
				else { $Sec = $TimeSec }
				$Value = $Year + "-" + $Day + "-" + $Month + "T" + $Hour + ":" + $Min + ":" + $Sec
			}
			elseif($Value -match "[0-9]+/[0-9]+/\d\d\d\d") 
			{ 
				$Year = ($Value.Split("/")[2] | % { $_ -split ' ' })[0]
				$MonthCharacters = ($Value.Split("/")[0]) | measure-object -character | select -expandproperty characters
				if($MonthCharacters -le 1) { $Month = "0" + ($Value.Split("/")[0]) }
				else { $Month = $Value.Split("/")[0] }
				$DayCharacters = ($Value.Split("/")[1]) | measure-object -character | select -expandproperty characters
				if($DayCharacters -le 1) { $Day = "0" + ($Value.Split("/")[1]) }
				else { $Day = $Value.Split("/")[1] }
				$Time = "00:00:00"
				$Value = $Year + "-" + $Day + "-" + $Month + "T" + $Time
			}
			
			$JsonSB =  '"' + $Property + '":"' + $Value + '",' 
			return $JsonSB
			
		}
		elseif($Property.Contains("IpAddress") -or $Property.Contains("IPAddress"))
		{
			if(($Property -ne "") -and ($Value -ne ""))
			{
				$JsonSB =  '"' + $Property + '":"' + $Value + '",' 
				return $JsonSB
			}
			else
			{
				return $null
			}
		}
		else
		{
			$fChars = '"', "'", '?', '*' # '-', ':', '?', '/', '\', '|', '*', '<', '>' 
			$pat = [string]::join('|', ($fChars | % {[regex]::escape($_)}))
			$Value = $Value -replace $pat, ' '
			$fChars = '\'
			$pat = [string]::join('|', ($fChars | % {[regex]::escape($_)}))
			$Value = $Value -replace $pat, '/'
	
			if(isNumeric $Value) 
			{
				$JsonSB = ' "' + $Property + '":' + $Value + ','
				return $JsonSB
			}
			elseif($Value -is [double])
			{
				$JsonSB = ' "' + $Property + '":' + $Value + ','
				return $JsonSB
			}
			elseif($Value -is [string])
			{
				$TestDouble = $Value -as [double]
				if($TestDouble)
				{
					$JsonSB = ' "' + $Property + '":' + $Value + ','
					return $JsonSB
				}
				else
				{
					if(($Property -ne "") -and ($Value -ne ""))
					{
						if($Value.contains("`n"))
						{
							$Value = $Value.replace("`n", " ")
						}
						$JsonSB =  '"' + $Property + '":"' + $Value + '",' 
						return $JsonSB
					}
					else
					{
						return $null
					}
				}
			}
			elseif($Value -is [object])
			{
				Write-Log "WARNING: $Property Value is an object."
				return $null
			}
			else
			{
				Write-Log "WARNING: $Property is not a known type."
				return $null
			}
		}
	}
	else
	{
		return $null
	}
}

function Test-WMI_Connection(){
	Write-Log "Info: Testing WMI Connection"
	if($HostInfoIPAddress){ Write-Log "INFO: Host IP Address: $HostInfoIPAddress" }
	else { Write-Log "ERROR: No Host IP Address" }
	if($cred) { Write-Log "INFO: Credentials Provided" }
	else { Write-Log "WARNING: Credentials Not Provided" }
	$ConnectionType = 0  # 0 - Not Connected, 1 - Connected with provided Creds, 2 - Connects with system Creds
	try{
		$wmi = gwmi win32_bios -ComputerName $HostInfoIPAddress -ErrorAction SilentlyContinue 
		if($wmi){ 
		$ConnectionType = 2
		Write-Log "SUCCESS: Connection Made With System Credentials"
		}
	}
	catch{
		$wmi = gwmi win32_bios -ComputerName $HostInfoIPAddress -Credential $cred -ErrorAction SilentlyContinue 
		if($wmi){ 
		$ConnectionType = 1
		Write-Log "SUCCESS: Connection Made With Provided Credentials"
		}
	}
	if($ConnectionType -eq 0)
	{
		Write-Log "ERROR: Connection Could Not Be Made"
		throw
	}
	return $ConnectionType
}

function Get-Win32_Propertie($ConnectionType, $Class, $Instance){
	Write-Log "INFO: Getting WMI Property"
	Write-Log "INFO: ConnectionType: $ConnectionType  Class: $Class  Instance: $Instance"
	if($ConnectionType -eq 1){ 
		try { $Propertie = Get-WmiObject -Class $Class -Credential $cred -ComputerName $HostInfoIPAddress}
		catch { 
		Write-Log "WARNING: $Class No Data Found"
		$Propertie = $null
		}
	}
	elseif($ConnectionType -eq 2){ 
		try { $Propertie = Get-WmiObject -Class $Class -ComputerName $HostInfoIPAddress }
		catch { 
		Write-Log "WARNING: $Class No Data Found"
		$Propertie = $null
		}
	}
	if($Propertie -ne $null)
	{
		if($Instance){ Return $Propertie.$Instance }
		else { Return $Propertie}
	}
	else{
		Write-Log "WARNING: No Information Found For $Class"
	}
}

Function Get-SQLDataSet($query, $database){
	if(!$query) { Write-Log "ERROR: No Query Defined" }
	if(!$Database) { Write-Log "ERROR: No Database Defined" }
	if($query -and $Database){
		$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
		$SqlConnection.ConnectionString = "Data Source=$HostInfoIPAddress;Initial Catalog=$Database;User ID=$SQLUserName; Password=$SQLPassword"
		$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
		$SqlCmd.Connection = $SqlConnection
		$SqlConnection.Open()
  		$SqlCmd.CommandText = $query
  		$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
  		$SqlAdapter.SelectCommand = $SqlCmd
  		$DataSet = New-Object System.Data.DataSet
  		$nRecs = $SqlAdapter.Fill($DataSet)
  		$nRecs | Out-Null
  		$objTable = $DataSet.Tables[0]
  		return $objTable
		$SqlConnection.Close()
	}
	else { return $null }
}

function Copy-Files($SourceFile, $Type){
	$Drive = $SourceFile.Split("{:}")[0]
	$Path = Split-Path $SourceFile -NoQualifier
	Write-Log "INFO: Coping Files"
	$ErrorActionPreference = "SilentlyContinue"	
	if(!(Test-Path ($LocalIO + "\Data\" + $Type))) { mkdir ($LocalIO + "\Data\" + $Type)}
	try{
		net use ("\\" + $HostInfoIPAddress + ('\' + $Drive + '$\')) $networkCred.Password /USER:$networkCred.UserName
		Copy-Item ("\\" + $HostInfoIPAddress + ('\' + $Drive + '$') + $Path) ($LocalIO + "\Data\" + $Type + "\" + $OutputFileNameLog)
		Write-Log "INFO: Coped From: $SourceFile"
	}
	catch{ Write-Log "Info: Could Not Copy From: $SourceFile" }
}

function DataRow-ToJson($Results, $Type, $HeaderJson){
	if(($Results -ne "") -and ($Results -ne $null))
	{
		foreach($Result in $Results)
		{
			for($i=0;$i -le ($Result.Table.Columns.count);$i++)
			{
				$Name = $Result.Table.Columns[$i].ColumnName # If name has "HostName, IpAddress, or anything in header remove it, Also @timestamp
				if(($Result.($Name)) -ne $null)
				{
					$Value = Json-SB $Name ($Result.($Name))
					if(($Value -ne "") -or ($Value -ne $null)) { $ValueStringJason = $ValueStringJason + $Value }
				}
			}
			if($ValueStringJason)
			{
				Add-Content ($LocalIO + "\Data\" + $Type + "\" + $OutPutFileNameJson) ('{"index":{"_index":"' + $Index + '","_type":"' + $Type +'"}}')
				Add-Content ($LocalIO + "\Data\" + $type + "\" + $OutPutFileNameJson) ($HeaderJson + ', "keyType":"' + $Type + '",' + ($ValueStringJason.Substring(0,$ValueStringJason.Length-1)) + ' }')
				$ValueStringJason = "";
			}
		}
		return $true
	}
	else { return $false }
}

	##########################################################
	###		Global										   ###
	##########################################################
	#region
	$Index = "hcv1"
	$sw = [Diagnostics.Stopwatch]::StartNew()
	$sw.Start() # Start Stopwatch
	if(!$HostInfoIPAddress){ $HostInfoIPAddress = "127.0.0.1"}
	if(!$HostInfoComputerName){ $HostInfoComputerName = "UnknownHost"}
	if(!$WindowsUserName) { 
		Write-Log "ERROR: You need a Windows User Name"
		throw 
	}
	if(!$WindowsPassword) {
		Write-Log "ERROR: You need a Windows Password"
		throw 
	}
	
	$secstr = New-Object -TypeName System.Security.SecureString
	$WindowsPassword.ToCharArray() | ForEach-Object {$secstr.AppendChar($_)}
	$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $WindowsUserName, $secstr
	$networkCred = $cred.GetNetworkCredential()
	
	[xml]$XMLDeploymentInfo = Get-Content ($LocalIO + "\Data\DeploymentInfo.xml")
	$keyCustomerName = $XMLDeploymentInfo.Deployment.keyCustomerName
	$keyLicenseID = $XMLDeploymentInfo.Deployment.keyLicenseID
	$keyDateGatherDateTime = $XMLDeploymentInfo.Deployment.keyDateGatherDateTime
	$LogRhythmMajorVersion = $XMLDeploymentInfo.Deployment.LogRhythmMajorVersion
	$LogRhythmMinorVersion = $XMLDeploymentInfo.Deployment.LogRhythmMinorVersion
	
	$TmpDate = Get-Date
	$DateTime = ($TmpDate.ToString("yyyy-MM-dd HH:mm:ss").split(' ')[0] + "T" + $TmpDate.ToString("yyyy-MM-dd HH:mm:ss").split(' ')[1])

	if($keyCustomerName -and $keyLicenseID -and $keyDateGatherDateTime)
	{
		$OutputFileNameJson = $keyLicenseID.ToString() + "." + $HostInfoComputerName + "." + (Get-Date -Format "MMddyyyy").ToString() + ".json"  
		$OutputFileNameTXT = $keyLicenseID.ToString() + "." + $HostInfoComputerName + "." + (Get-Date -Format "MMddyyyy").ToString() + ".txt"  
		$OutputFileNameLog = $keyLicenseID.ToString() + "." + $HostInfoComputerName + "." + (Get-Date -Format "MMddyyyy").ToString() + ".log"  
	}
	else
	{
		Write-Log "ERROR: Customer Information Could Not Be Found From Deployment [XML]"
		throw 
	}
	$ConnectionType = Test-WMI_Connection
	
	$HeaderJson =  '{"@timestamp":"' + $DateTime + '","keyDataGatherDateTime":"' + $keyDateGatherDateTime + '","keyCustomerName":"' + $keyCustomerName + '","keyLicenseID":' + $keyLicenseID.ToString() + ',"keyHostName":"' + $HostInfoComputerName + '","keyVersion":"7.1.3"'
	$HeaderJsonNoTimeStamp =  '{"keyDataGatherDateTime":"' + $keyDateGatherDateTime + '","keyCustomerName":"' + $keyCustomerName + '","keyLicenseID":' + $keyLicenseID.ToString() + ',"keyHostName":"' + $HostInfoComputerName + '","keyVersion":"7.1.3"'
	
	Write-Log "REPORT: ------------------------------------------"
	Write-Log "REPORT: AIE - $HostInfoComputerName"
	Write-Log "REPORT: ------------------------------------------"
	Write-Log "REPORT: "
	
	#endregion
	
	###############################
	###			WMI				###
	###############################	
	#region
	Write-Log "SUCCESS: Starting Gathering WMI Data Data"
	
		$WMIList = "Win32_ComputerSystem",
			   "Win32_OperatingSystem",
			   "Win32_Processor",
			   "Win32_DiskDrive",
			   "Win32_DiskPartition",
			   "Win32_LogicalDisk",
			   "Win32_LogicalDiskToPartition",
			   "Win32_PhysicalMemory",
			   "Win32_NetworkAdapter"
	
	foreach($WMIItem in $WMIList)
	{
		$Type = $WMIItem.split("_")[1]
		Write-Log "SUCCESS: Gathering $Type Information"
	
		if(!(Test-Path ($LocalIO + "\Data\" + $Type))) { mkdir ($LocalIO + "\Data\" + $Type)}
		if(!(Test-Path ($LocalIO + "\Data\" + $Type + "\" + $OutputFileNameJson))){New-Item ($LocalIO + "\Data\" + $Type + "\" + $OutputFileNameJson) -type file}
		
		$WMIPropertyList = Get-Win32_Propertie $ConnectionType $WMIItem | Get-Member -MemberType Properties
		$WMIObjects = Get-Win32_Propertie $ConnectionType $WMIItem
		foreach($WMIObject in $WMIObjects)
		{
			foreach($WMIProperty in $WMIPropertyList)
			{
				$Value = Json-SB ($WMIProperty.Name) ($WMIObject.($WMIProperty.Name))
				if(($Value -ne "") -or ($Value -ne $null)) { $ValueStringJason = $ValueStringJason + $Value }
			}
			Add-Content ($LocalIO + "\Data\" + $Type + "\" + $OutPutFileNameJson) ('{"index":{"_index":"' + $Index + '","_type":"' + $Type +'"}}')
			Add-Content ($LocalIO + "\Data\" + $type + "\" + $OutPutFileNameJson) ($HeaderJson + ', "keyType":"' + $Type + '",' + ($ValueStringJason.Substring(0,$ValueStringJason.Length-1)) + ' }')
			$ValueStringJason = "";
		}
	}
	Write-Log "SUCCESS: Completed Gathering WMI Data Data"
	Write-Log "REPORT: WMI Objects Collected - PASSED"
	#endregion
	
	###############################
	###			Logs			###
	###############################
	#region
	
		### ERRORLOG ###
		Copy-Files 'C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\LOG\ERRORLOG' 'ERRORLOG'
	
		### Data Indexer Logs ###
		
		$AIELogsList = "LRAIEComMgr",
					   "LRAIEEngine"
		
		foreach($AIELog in $AIELogsList)
		{
			Write-Log "SUCCESS: Gathering $AIELog Logs"
			Copy-Files ('C:\Program Files\LogRhythm\LogRhythm AI Engine\logs\' + $AIELog + '.log') $AIELog
		}
		Write-Log "REPORT: Logs - PASSED"
	#endregion
	
	$sw.stop() #Stop the stop watch
	$SWMinutes = $sw.Elapsed.Minutes
	$SWSeconds = $sw.Elapsed.Seconds
	Write-Log "REPORT: Step Completed: - $SWMinutes Minutes $SWSeconds Seconds"
	Write-Log "REPORT: "