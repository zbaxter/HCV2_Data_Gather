##########################################################
###		Platform Manager Health Check 				   ###
##########################################################

# Start DEV
#	function Write-Log($Message) { }#Write-Output $Message };
#
#	$SQLUserName= "sa"
#	$SQLPassword = "logrhythm!1"
#	$WindowsUserName = ".\administrator"
#	$WindowsPassword = "logrhythm!1"
#	$HostInfoIPAddress = "10.7.13.100"
#	$LocalIO = "C:\Temp\DGv1"
#	
# End DEV

function isNumeric ($x) {
    $x2 = 0
    $isNum = [System.Int32]::TryParse($x, [ref]$x2)
    return $isNum
}

function Json-SB($Name, $Value){
	$JsonSB = ""
	if(($Name -ne $null) -and ($Value -ne $null))
	{
		if($Name.Contains("Date") -or $Name.Contains("LastHeartbeat") -or  ($Name -eq "Timestamp")) # Value meets this data time format 10/2/2015 10:56:24 PM
		{
			if($Name -eq "Timestamp") { $Name = "@timestamp" }
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
			
			$JsonSB =  '"' + $Name + '":"' + $Value + '",' 
			return $JsonSB
			
		}
		elseif($Name.Contains("IpAddress") -or $Name.Contains("IPAddress"))
		{
			if(($Name -ne "") -and ($Value -ne ""))
			{
				$JsonSB =  '"' + $Name + '":"' + $Value + '",' 
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
				$JsonSB = ' "' + $Name + '":' + $Value + ','
				return $JsonSB
			}
			elseif($Value -is [double])
			{
				$JsonSB = ' "' + $Name + '":' + $Value + ','
				return $JsonSB
			}
			elseif($Value -is [string])
			{
				$TestDouble = $Value -as [double]
				if($TestDouble)
				{
					$JsonSB = ' "' + $Name + '":' + $Value + ','
					return $JsonSB
				}
				else
				{
					if(($Name -ne "") -and ($Value -ne ""))
					{
						if($Value.contains("`n"))
						{
							$Value = $Value.replace("`n", " ")
						}
						$JsonSB =  '"' + $Name + '":"' + $Value + '",' 
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
				Write-Log "WARNING: $Name Value is an object."
				return $null
			}
			else
			{
				Write-Log "WARNING: $Name is not a known type."
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
	catch{ Write-Log "WARNING: Could Not Copy From: $SourceFile" }
}

function DataRow-ToJson($Results, $Type, $HeaderJson){
	if(($Results -ne "") -and ($Results -ne $null))
	{
		foreach($Result in $Results)
		{
			for($i=0;$i -le ($Result.Table.Columns.count);$i++)
			{
				$Name = $Result.Table.Columns[$i].ColumnName # If name has "keyHostName, IpAddress, or anything in header remove it, Also @timestamp
				if(($Result.($Name)) -ne $null)
				{
					$Value = Json-SB $Name ($Result.($Name))
					if(($Value -ne "") -or ($Value -ne $null)) { $ValueStringJason = $ValueStringJason + $Value }
				}
			}
			if($ValueStringJason)
			{
				Add-Content ($LocalIO + "\Data\" + $Type + "\" + $OutPutFileNameJson) ('{"index":{"_index":"' + $Index + '","_type":"' + $Type +'"}}')
				Add-Content ($LocalIO + "\Data\" + $Type + "\" + $OutPutFileNameJson) ($HeaderJson + ', "keyType":"' + $Type + '",' + ($ValueStringJason.Substring(0,$ValueStringJason.Length-1)) + ' }')
				$ValueStringJason = "";
			}
		}
		return $true
	}
	else { return $false }
}

###########################
###		One Time Run	###
###########################
function Run-OneTime()
{
	##########################################################
	###		Global										   ###
	##########################################################
	
	#region
	$Index = "hcv1"
	
	$sw = [Diagnostics.Stopwatch]::StartNew()
	$sw.Start() # Start Stopwatch
	if(!$HostInfoIPAddress){ $HostInfoIPAddress = "127.0.0.1"}
	if(!$HostInfoComputerName){ $HostInfoComputerName = $env:computername}
	if(!$WindowsUserName) { 
		Write-Log "ERROR: You need a Windows User Name"
		throw 
	}
	if(!$WindowsPassword) {
		Write-Log "ERROR: You need a Windows Password"
		throw 
	}
	if(!$SQLUserName) { 
		Write-Log "ERROR: You need a SQL User Name"
		throw 
	}
	if(!$SQLPassword) {
		Write-Log "ERROR: You need a SQL Password"
		throw 
	}
	
	$secstr = New-Object -TypeName System.Security.SecureString
	$WindowsPassword.ToCharArray() | ForEach-Object {$secstr.AppendChar($_)}
	$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $WindowsUserName, $secstr
	$networkCred = $cred.GetNetworkCredential()
	
	#$ConnectionType = Test-WMI_Connection
	
	$TmpDate = Get-Date
	$DateTime = ($TmpDate.ToString("yyyy-MM-dd HH:mm:ss").split(' ')[0] + "T" + $TmpDate.ToString("yyyy-MM-dd HH:mm:ss").split(' ')[1])
	
	$query = "SELECT [LicenseID],[LicensedTo],[MajorVersion],[MinorVersion]
	FROM [LogRhythmEMDB].[dbo].[SCLicense]
	where LicenseType = 1 
	and MasterLicenseID is NULL"
	$Results = Get-SQLDataSet $query "LogRhythmEMDB"
	
	$keyCustomerName = $Results.LicensedTo
	$keyLicenseID = $Results.LicenseID.ToString()
	$keyDateGatherDateTime = $DateTime.ToString()
	$LogRhythmMajorVersion = $Results.MajorVersion.ToString()
	$LogRhythmMinorVersion = $Results.MinorVersion.ToString()
	
	if($keyLicenseID -and $keyCustomerName)
	{
		$OutputFileNameJson = $Results.LicenseID.ToString() + "." + $HostInfoComputerName + "." + (Get-Date -Format "MMddyyyy").ToString() + ".json"  
		$OutputFileNameTXT = $Results.LicenseID.ToString() + "." + $HostInfoComputerName + "." + (Get-Date -Format "MMddyyyy").ToString() + ".txt"  
		$OutputFileNameLog = $Results.LicenseID.ToString() + "." + $HostInfoComputerName + "." + (Get-Date -Format "MMddyyyy").ToString() + ".log"  
	
		if(Test-Path ($LocalIO + "\Data\DeploymentInfo.xml")) { Remove-Item ($LocalIO + "\Data\DeploymentInfo.xml") }

		# Set the File Name  
 		$filePath = ($LocalIO + "\Data\DeploymentInfo.xml")
 		# Create The Document  
 		$XmlWriter = New-Object System.XMl.XmlTextWriter($filePath,$Null)  
		# Set The Formatting  
		$xmlWriter.Formatting = "Indented"  
 		$xmlWriter.Indentation = "4"  
 		# Write the XML Decleration  
 		$xmlWriter.WriteStartDocument()  
 		# Set the XSL  
 		$XSLPropText = "type='text/xsl' href='style.xsl'"  
 		$xmlWriter.WriteProcessingInstruction("xml-stylesheet", $XSLPropText)  
 		# Write Root Element  
 		$xmlWriter.WriteStartElement("Deployment")  
      	# Write the Document  
      	$xmlWriter.WriteElementString("keyDateGatherDateTime", $keyDateGatherDateTime) 
		$xmlWriter.WriteElementString("keyCustomerName",$keyCustomerName) 
		$xmlWriter.WriteElementString("keyLicenseID", $keyLicenseID) 
		$xmlWriter.WriteElementString("keyVersion", "7.1.3")   
		$xmlWriter.WriteElementString("LogRhythmMajorVersion", $LogRhythmMajorVersion) 
		$xmlWriter.WriteElementString("LogRhythmMinorVersion", $LogRhythmMinorVersion) 
		
		$query = "SELECT [StatsIP], [NodeName]
		FROM [LogRhythmEMDB].[dbo].[NGPNode]"
		$Results = Get-SQLDataSet $query "LogRhythmEMDB"
		
		foreach($Result in $Results)
		{
			$xmlWriter.WriteStartElement("DXServers")
			$xmlWriter.WriteElementString("DX_HostName", $Result.NodeName.ToString())
			$xmlWriter.WriteElementString("DX_IPAddress", $Result.StatsIP.ToString())
			$xmlWriter.WriteEndElement()
		}
		
 		$xmlWriter.Flush()  
 		$xmlWriter.Close() 
	
		if(Test-Path ($GlobalIO + "\DeploymentInfo.xml")) { Remove-Item ($GlobalIO + "\DeploymentInfo.xml") }

		Copy-Item -Path ($LocalIO + "\Data\DeploymentInfo.xml") -Destination ($GlobalIO + "\DeploymentInfo.xml")
	}
	else
	{
		Write-Log "ERROR: No LicenseID or Customer Name"
		throw 
	}
	
	$HeaderJson =  '{"@timestamp":"' + $DateTime + '","keyGatherDateTime":"' + $keyDateGatherDateTime + '","keyCustomerName":"' + $keyCustomerName + '","keyLicenseID":' + $keyLicenseID.ToString() + ',"keyHostName":"' + $HostInfoComputerName + '","keyVersion":"7.1.3"'
	$HeaderJsonNoTimeStamp =  '{"keyGatherDateTime":"' + $keyDateGatherDateTime + '","keyCustomerName":"' + $keyCustomerName + '","keyLicenseID":' + $keyLicenseID.ToString() + ',"keyHostName":"' + $HostInfoComputerName + '","keyVersion":"7.1.3"'
	
	$ConnectionType = Test-WMI_Connection
	
	Write-Log "REPORT: "
	Write-Log "REPORT: Health Check Report" # Start of Report
	Write-Log "REPORT: "
	Write-Log "REPORT: ------------------------------------------"
	Write-Log "REPORT: Platform Manager - $HostInfoComputerName"
	Write-Log "REPORT: ------------------------------------------"
	Write-Log "REPORT: "
	Write-Log "REPORT: Deployment XML - Created"
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
				if(($WMIProperty.Name) -eq "Status")
				{
					$Value = Json-SB ($Type + "Status") ($WMIObject.($WMIProperty.Name))
					if(($Value -ne "") -or ($Value -ne $null)) { $ValueStringJason = $ValueStringJason + $Value }
				}
				else
				{
					$Value = Json-SB ($WMIProperty.Name) ($WMIObject.($WMIProperty.Name))
					if(($Value -ne "") -or ($Value -ne $null)) { $ValueStringJason = $ValueStringJason + $Value }
				}
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
	###			SQL				###
	###############################
	#region
	
	Write-Log "SUCCESS: Starting Gathering SQL Data"
	
	##########################################################
	###		Database Locations (Event Manager)			   ###
	##########################################################
	#region
	Write-Log "SUCCESS: Starting Gathering Database Location Data"
	$Database = "Master"
	$Type = "DatabaseLocations"
	if(!(Test-Path ($LocalIO + "\Data\" + $Type))) { mkdir ($LocalIO + "\Data\" + $Type)}
	if(!(Test-Path ($LocalIO + "\Data\" + $Type + "\" + $OutputFileNameJson))){New-Item ($LocalIO + "\Data\" + $Type + "\" + $OutputFileNameJson) -type file}
					
	$ListDatabaseName = "LogRhythm_Alarms", "LogRhythm_Events", "LogRhythm_LogMart", "LogRhythmEMDB"
					
	foreach($DatabaseName in $ListDatabaseName)
	{
		$Query = "use $DatabaseName SELECT name, physical_name FROM sys.database_files"
		$Results = Get-SQLDataSet $Query $Database
		if(DataRow-ToJson $Results $Type $HeaderJson) {
			Write-Log "REPORT: Database Locations - PASSED"
			Write-Log "SUCCESS: Completed Gathering $DatabaseName  Data"
		}
		else {
			Write-Log "WARNING: $HostInfoComputerName - Gathered NO $DatabaseName  Data"
			Write-Log "REPORT: Database Locations - FAILED"
		}
	}		
	#endregion
	
	##########################################################
	###		Get Database Space (Event Manager)			   ###
	##########################################################
	#region
	Write-Log "SUCCESS: Starting Gathering Database Space Data"
	$Database = "LogRhythmEMDB"
	$Type = "DatabaseSpace"
	if(!(Test-Path ($LocalIO + "\Data\" + $Type))) { mkdir ($LocalIO + "\Data\" + $Type)}
	if(!(Test-Path ($LocalIO + "\Data\" + $Type + "\" + $OutputFileNameJson))){New-Item ($LocalIO + "\Data\" + $Type + "\" + $OutputFileNameJson) -type file}

	$ListDB = "LogRhythm_Alarms","LogRhythm_Events","LogRhythm_LogMart","LogRhythmEMDB"
		
	foreach($DB in $ListDB)
	{
		if($HostInfoComputerName) { $ValueStringJason = $ValueStringJason + ' "keyHostName":"' + $HostInfoComputerName + '",' }
		if($HostInfoIPAddress) { $ValueStringJason = $ValueStringJason + ' "IpAddress":"' + $HostInfoIPAddress + '",' }
		$query = "use $DB exec sp_spaceused"
		$Results = Get-SQLDataSet $query $Database
		if(($Results -ne "") -and ($Results -ne $null))
		{
			$ValueStringJason = $ValueStringJason + ' "DataBaseName":"' + $DB + '",'
			if($Results.database_size) { $ValueStringJason = $ValueStringJason + ' "' + ("DBSize") + '":' + ($Results.database_size).Substring(0,(($Results.database_size).Length)-3) + ',' }
			if($Results.("unallocated space")) { $ValueStringJason = $ValueStringJason + ' "' + ("DBFreeSpace") + '":' + ($Results.("unallocated space")).Substring(0,(($Results.("unallocated space")).Length)-3) + ',' }
				$sizeParse = ($Results.database_size).split(" ")
				$sizeInt = [int]$sizeParse[0]
				$unallocatedParse = ($Results.("unallocated space").split(" "))
				$unallocatedInt = [int]$unallocatedParse[0]
				$Value = (($unallocatedInt / $sizeInt) * 100)
			if(($Value -ne "") -or ($Value -ne $null)) { $ValueStringJason = $ValueStringJason + ' "' + ($Results.database_name + "DBPercentageFree") + '":' + $Value + ',' }
		
			Add-Content ($LocalIO + "\Data\" + $Type + "\" + $OutPutFileNameJson) ('{"index":{"_index":"' + $Index + '","_type":"' + $Type +'"}}')
			Add-Content ($LocalIO + "\Data\" + $type + "\" + $OutPutFileNameJson) ($HeaderJson + ',' + ($ValueStringJason.Substring(0,$ValueStringJason.Length-1)) + ' }')
			$ValueStringJason = "";
			Write-Log "SUCCESS: Gathered $DB Database Size"
		}
		else
		{
			Write-Log "Waring: $HostInfoComputerName - Gathered No " + $DB + " Data"
		}
	}
	Write-Log "REPORT: Database Space - PASSED"
	Write-Log "SUCCESS: Completed Gathering Database Space Data"
	#endregion
	
	##########################################################
	###		Enabled Alarms (Event Manager)         	       ###
	##########################################################
	#region
	$TypeFullName = "Enabled Alarms"
	Write-Log "SUCCESS: Starting Gathering Enabled Alarms Data"
	$Database = "LogRhythmEMDB"
	$Type = "EnabledAlarms"
	if(!(Test-Path ($LocalIO + "\Data\" + $Type))) { mkdir ($LocalIO + "\Data\" + $Type)}
	if(!(Test-Path ($LocalIO + "\Data\" + $Type + "\" + $OutputFileNameJson))){New-Item ($LocalIO + "\Data\" + $Type + "\" + $OutputFileNameJson) -type file}
	
	$query = "USE LogRhythmEMDB SELECT AlarmRuleID,AlarmType,Name,ShortDesc,DateUpdated
	FROM LogRhythmEMDB.dbo.AlarmRule 
	Where AlarmRule.Enabled = 1 
	Order by AlarmRuleID asc"
	$Results = Get-SQLDataSet $query $Database

	if(DataRow-ToJson $Results $Type $HeaderJson) {
		Write-Log "REPORT: Enabled Alarms - PASSED"
		Write-Log "SUCCESS: Completed Gathering $TypeFullName Data"
		}
	else {
		Write-Log "WARNING: $HostInfoComputerName - Gathered NO $TypeFullName Data"
		Write-Log "REPORT: Enabled Alarms - FAILED"
	}
	#endregion
	
	##########################################################
	###		Enabled GLPRS (Event Manager)      	       ###
	##########################################################
	#region
	$TypeFullName = "Enabled GLPRS"
	Write-Log "SUCCESS: Starting Gathering Enabled GLPRs Data"
	$Database = "LogRhythmEMDB"
	$Type = "EnabledGLPRS"
	if(!(Test-Path ($LocalIO + "\Data\" + $Type))) { mkdir ($LocalIO + "\Data\" + $Type)}
	if(!(Test-Path ($LocalIO + "\Data\" + $Type + "\" + $OutputFileNameJson))){New-Item ($LocalIO + "\Data\" + $Type + "\" + $OutputFileNameJson) -type file}

	$query = "USE LogRhythmEMDB SELECT GlobalLogProcessingRuleID,Name,LongDesc,Status,SortOrder,DateExpires,DateUpdated,RecordStatus
	FROM LogRhythmEMDB.dbo.GlobalLogProcessingRule
	Order by GlobalLogProcessingRuleID asc"
	$Results = Get-SQLDataSet $query $Database
	
	if(DataRow-ToJson $Results $Type $HeaderJson) {
		Write-Log "REPORT: Enabled GLPRS - PASSED"
		Write-Log "SUCCESS: Completed Gathering $TypeFullName Data"
		}
	else {
		Write-Log "WARNING: $HostInfoComputerName - Gathered NO $TypeFullName Data"
		Write-Log "REPORT: Enabled GLPRS - FAILED"
	}
	#endregion

	##########################################################
	###		Enabled AIE Rules (Event Manager)	 	       ###
	##########################################################
	#region
	$TypeFullName = "Enabled AIE Rules"
	Write-Log "SUCCESS: Starting Gathering Enabled AIE Rule Data"
	$Database = "LogRhythmEMDB"
	$Type = "EnabledAIERules"
	if(!(Test-Path ($LocalIO + "\Data\" + $Type))) { mkdir ($LocalIO + "\Data\" + $Type)}
	if(!(Test-Path ($LocalIO + "\Data\" + $Type + "\" + $OutputFileNameJson))){New-Item ($LocalIO + "\Data\" + $Type + "\" + $OutputFileNameJson) -type file}

	$query = "USE LogRhythmEMDB SELECT aieRule.AIERuleID,aieRule.Name,aieRule.ShortDesc,aieRule.DateUpdated
	FROM LogRhythmEMDB.dbo.AIERule as aieRule
	Inner join LogRhythmEMDB.dbo.AIERuleToEngine as aieRuleToEngine on aieRule.AIERuleID = aieRuleToEngine.AIERuleID 
	Where aieRuleToEngine.Enabled = 1
	Order by AlarmRuleID asc"
	$Results = Get-SQLDataSet $query "LogRhythmEMDB"

	if(DataRow-ToJson $Results $Type $HeaderJson) {
		Write-Log "REPORT: Enabled AIE Rules - PASSED"
		Write-Log "SUCCESS: Completed Gathering $TypeFullName Data"
		}
	else {
		Write-Log "WARNING: $HostInfoComputerName - Gathered NO $TypeFullName Data"
		Write-Log "REPORT: Enabled AIE Rules - FAILED"
	}
	#endregion
	
	##########################################################
	###		Get Mediator Tuning Parameters (Event Manager) ###
	##########################################################
	#region
	Write-Log "SUCCESS: Starting Gathering Mediator Tuning Parameter Data"
	$Database = "LogRhythmEMDB"
	$Type = "MediatorTuningParameters"
	if(!(Test-Path ($LocalIO + "\Data\" + $Type))) { mkdir ($LocalIO + "\Data\" + $Type)}
	if(!(Test-Path ($LocalIO + "\Data\" + $Type + "\" + $OutputFileNameJson))){New-Item ($LocalIO + "\Data\" + $Type + "\" + $OutputFileNameJson) -type file}
	
	$query = "select * from dbo.Mediator"
	$Results = Get-SQLDataSet $query "LogRhythmEMDB"
	
	$AIEConfigArray = @()
	$NGLMConfigArray = @() 
	
	foreach($Result in $Results)
	{
		for($i=0;$i -le ($Result.Table.Columns.count);$i++)
		{
			$Name = $Result.Table.Columns[$i].ColumnName
			if(($Name -eq "DataProviderConfig") -or ($Name -eq "StorageOverseerDataProviderConfig"))
			{
				if(($Result.($Name) -ne "") -and ($Result.($Name) -ne $null))
				{
					$XMLPass = $true
					
					try
					{
						$XML = [xml]($Results[$i].($Name)) 
					}
					catch
					{
						$XMLPass = $false
					}
				
					if(($Name -eq "DataProviderConfig") -and ($XMLPass -eq $true))
					{
						if($XML.AIEDataProviderConfig)
						{
							$ListAIEConfigProperties = $XML.AIEDataProviderConfig | gm -MemberType Property | select Name -ErrorAction SilentlyContinue
						
							if($ListAIEConfigProperties)
							{
								$Value = Json-SB "ConfigName" "AIE Data Provider Config"
								if(($Value -ne "") -or ($Value -ne $null)) { $ValueStringJasonXML = $ValueStringJasonXML + $Value }
						
						
								foreach($AIEConfigProperty in $ListAIEConfigProperties)
								{
									$Value = Json-SB ($AIEConfigProperty.Name) ($XML.AIEDataProviderConfig.($AIEConfigProperty.Name))
									if(($Value -ne "") -or ($Value -ne $null)) { $ValueStringJasonXML = $ValueStringJasonXML + $Value }
								}
								
								$AIEConfigArray += $ValueStringJasonXML
								$ValueStringJasonXML = ""
							}
						}
					}
					elseif(($Name -eq "StorageOverseerDataProviderConfig") -and ($XMLPass -eq $true))
					{
						if($XML.NglmDataProviderConfig)
						{
							$ListNGLMConfigProperties = $XML.NglmDataProviderConfig | gm -MemberType Property | select Name -ErrorAction SilentlyContinue
						
							if($ListNGLMConfigProperties)
							{
								$Value = Json-SB "ConfigName" "Storage Overseer Data Provider Config"
								if(($Value -ne "") -or ($Value -ne $null)) { $ValueStringJasonXML = $ValueStringJasonXML + $Value }
							
								foreach($NGLMConfigProperty in $ListNGLMConfigProperties)
								{
									$Value = Json-SB ($NGLMConfigProperty.Name) ($XML.NglmDataProviderConfig.($NGLMConfigProperty.Name))
									if(($Value -ne "") -or ($Value -ne $null)) { $ValueStringJasonXML = $ValueStringJasonXML + $Value }
								}
							
								$NGLMConfigArray += $ValueStringJasonXML
								$ValueStringJasonXML = ""
							}
						}
					}
				}
			}
			else
			{
				$Value = Json-SB $Name ($Result.($Name))
				if(($Value -ne "") -or ($Value -ne $null)) { $ValueStringJason = $ValueStringJason + $Value }
			}
		}
	}
	
	Add-Content ($LocalIO + "\Data\" + $Type + "\" + $OutPutFileNameJson) ('{"index":{"_index":"' + $Index + '","_type":"' + $Type +'"}}')
	Add-Content ($LocalIO + "\Data\" + $type + "\" + $OutPutFileNameJson) ($HeaderJson + ',' + ($ValueStringJason.Substring(0,$ValueStringJason.Length-1)) + ' }')
	$ValueStringJason = "";
	
	if($AIEConfigArray.Count -gt 0)
	{
		foreach($AIEConfig in $AIEConfigArray)
		{
			Add-Content ($LocalIO + "\Data\" + $Type + "\" + $OutPutFileNameJson) ('{"index":{"_index":"' + $Index + '","_type":"' + $Type +'"}}')
			Add-Content ($LocalIO + "\Data\" + $type + "\" + $OutPutFileNameJson) ($HeaderJson + ',' + ($AIEConfig.Substring(0,$AIEConfig.Length-1)) + ' }')
		}
	}
	
	if($NGLMConfigArray)
	{
		foreach($NGLMConfig in $NGLMConfigArray)
		{
			Add-Content ($LocalIO + "\Data\" + $Type + "\" + $OutPutFileNameJson) ('{"index":{"_index":"' + $Index + '","_type":"' + $Type +'"}}')
			Add-Content ($LocalIO + "\Data\" + $type + "\" + $OutPutFileNameJson) ($HeaderJson + ',' + ($NGLMConfig.Substring(0,$NGLMConfig.Length-1)) + ' }')
		}
	}
	
	
	Write-Log "REPORT: Mediator Tuning Parameters - PASSED"
	Write-Log "SUCCESS: Completed Gathering Mediator Tuning Parameter Data"
	#endregion
	
	##########################################################
	###		License Info (Event Manager)		           ###
	##########################################################
	#region
	$TypeFullName = "License Info"
	Write-Log "SUCCESS: Starting Gathering License Info Data"
	$Database = "LogRhythmEMDB"
	$Type = "License"
	if(!(Test-Path ($LocalIO + "\Data\" + $Type))) { mkdir ($LocalIO + "\Data\" + $Type)}
	if(!(Test-Path ($LocalIO + "\Data\" + $Type + "\" + $OutputFileNameJson))){New-Item ($LocalIO + "\Data\" + $Type + "\" + $OutputFileNameJson) -type file}
	
	$query = "SELECT [MajorVersion],[MinorVersion],[DateUpdated]
	FROM [LogRhythmEMDB].[dbo].[SCLicense]
	where LicenseType = 1 
	and MasterLicenseID is NULL"
	
	$Results = Get-SQLDataSet $query $Database
	
	if(DataRow-ToJson $Results $Type $HeaderJson) {
		Write-Log "REPORT: License Info - PASSED"
		Write-Log "SUCCESS: Completed Gathering $TypeFullName Data"
		}
	else {
		Write-Log "WARNING: $HostInfoComputerName - Gathered NO $TypeFullName Data"
		Write-Log "REPORT: License Info - FAILED"
	}
	#endregion
	
	#######################################################################
	###		Daily Aggregate Log Volume Report (Event Manager)	        ###
	#######################################################################
	#region
	Write-Log "SUCCESS: Starting Gathering Daily Aggregate Log Volume Report Data"
	$Database = "LogRhythm_LogMart"
	$Type = "DailyAggregateLogVolumeReport"
	if(!(Test-Path ($LocalIO + "\Data\" + $Type))) { mkdir ($LocalIO + "\Data\" + $Type)}
	if(!(Test-Path ($LocalIO + "\Data\" + $Type + "\" + $OutputFileNameJson))){New-Item ($LocalIO + "\Data\" + $Type + "\" + $OutputFileNameJson) -type file}

	$query = "SELECT datepart(yy,statdate) as [Year],datepart(mm,statdate) as [Month],datepart(dd,statdate) as [Days],sum(countlogs) as [TotalLogs],sum(countidentifiedlogs)
	as [IdentifiedLogs],sum(countarchivedlogs) as [ArchivedLogs],sum(countevents) as [Events], sum(countonlinelogs) as [OnlineLogs], sum(countprocessedlogs) as [Processed], sum(CountDeduplicatedLogs) as [CountsDedupe],
	CASE WHEN ISNULL(SUM(CountDeduplicatedLogs), 0) <= 0 THEN 0
	Else (CAST(SUM(CountDeduplicatedLogs) AS FLOAT) / CAST(SUM(CountOnlineLogs)AS FLOAT)*100)
	End as [DedupePercentage]
	from [LogRhythm_LogMart].[dbo].[StatsMsgSourceCounts]
	where statdate >= dateadd(dd,-30,getutcdate()) and statdate <= getutcdate() group by datepart(yy,statdate),datepart(mm,statdate),datepart(dd,statdate) order by datepart(yy,statdate),
	datepart(mm,statdate),datepart(dd,statdate)"
	$Results = Get-SQLDataSet $query $Database
	
	if(($Results -ne "") -and ($Results -ne $null))
	{
		$ColumnNames =  "TotalLogs","IdentifiedLogs","ArchivedLogs","Events","OnlineLogs","Processed","CountsDedupe","DedupePercentage"
	
		for($i=0;$i -le ($Results.Count - 1);$i++){ 
		
			$Value = ""
			$measureMonth = ($Results[$i].Month).tostring() | Measure-Object -Character
			$countMonth = $measureMonth.Characters
			$measureDay = ($Results[$i].Days).tostring() | Measure-Object -Character
			$countDay = $measureDay.Characters
			if($countMonth -le 1) { $Month = "0" + ($Results[$i].Month).tostring() } 
			else { $Month = ($Results[$i].Month).tostring() }
			if($countDay -le 1) { $Day = "0" + ($Results[$i].Days).tostring() } 
			else { $Day = ($Results[$i].Days).tostring() }
			$Value = '"' + ($Results[$i].Year).tostring() + "-" + $Month + "-" + $Day + 'T00:00:00",'
	
			$ValueStringJason = $ValueStringJason + '"@timestamp":' + $Value
		
			foreach($Name in $ColumnNames)
			{
				$Value = Json-SB $Name ($Results[$i].($Name))
				if(($Value -ne "") -or ($Value -ne $null)) { $ValueStringJason = $ValueStringJason + $Value }
			}
			
			Add-Content ($LocalIO + "\Data\" + $Type + "\" + $OutPutFileNameJson) ('{"index":{"_index":"' + $Index + '","_type":"' + $Type +'"}}')
			Add-Content ($LocalIO + "\Data\" + $type + "\" + $OutPutFileNameJson) ($HeaderJsonNoTimeStamp + ', "keyType":"' + $Type + '",' + ($ValueStringJason.Substring(0,$ValueStringJason.Length-1)) + ' }')
			$ValueStringJason = "";
		}
		
		Write-Log "REPORT: Daily Aggregate Log Volume Report - PASSED"
	}
	else
	{
		Write-Log "WARNING: $HostInfoComputerName - Gathered No Daily Aggregate Log Volume Report"
		Write-Log "REPORT: Daily Aggregate Log Volume Report - FAILED"
	}
	Write-Log "SUCCESS: Completed Gathering Daily Aggregate Log Volume Report Data"
	#endregion

	#######################################################################
	###		Daily Dedupe By Type Log Volume Report (Event Manager)	    ###
	#######################################################################
	#region
	Write-Log "SUCCESS: Started Gathering Daily Dedupe By Type Log Volume Report Data"
	$Database = "LogRhythm_LogMart"
	$Type = "DailyDedupeByTypeLogVolumeReport"
	if(!(Test-Path ($LocalIO + "\Data\" + $Type))) { mkdir ($LocalIO + "\Data\" + $Type)}
	if(!(Test-Path ($LocalIO + "\Data\" + $Type + "\" + $OutputFileNameJson))){New-Item ($LocalIO + "\Data\" + $Type + "\" + $OutputFileNameJson) -type file}

	$query = "SELECT datepart(yy,statdate) as [Year],datepart(mm,statdate) as [Month],datepart(dd,statdate) As [Days]
	,MsgSrcType.[Name] As [LogSrcType] 
	,Sum(Mart.[CountLogs]) As [CountLogs] 
	,Sum(Mart.[CountIdentifiedLogs]) As [CountsIdentified] 
	,Sum(Mart.[CountArchivedLogs]) As [CountsArchived] 
	,Sum(Mart.[CountEvents]) As [CountsEvents] 
	,Sum(Mart.[CountOnlineLogs]) As [CountsOnline] 
	,Sum(Mart.[CountProcessedLogs]) As [CountsProcessed] 
	,Sum(Mart.[CountDeduplicatedLogs]) As [CountsDedupe] 
	,CASE WHEN ISNULL(SUM(CountDeduplicatedLogs), 0) <= 0 THEN 0 
	Else (CAST(SUM(CountDeduplicatedLogs) AS FLOAT) / CAST(SUM(CountOnlineLogs)AS FLOAT)*100) 
	End as [DedupePercentage] 
	FROM [LogRhythm_LogMart].[dbo].[StatsMsgSourceCounts] Mart, 
	[LogRhythmEMDB].[dbo].[MsgSource]MsgSrc, 
	[LogRhythmEMDB].[dbo].[MsgSourceType] MsgSrcType 
	where statdate >= dateadd(dd,-30,getutcdate()) and statdate <= getutcdate() 
	and MsgSrc.MsgSourceID = Mart.MsgSourceID 
	and MsgSrc.MsgSourceTypeID = MsgSrcType.MsgSourceTypeID 
	group by datepart(yy,statdate),datepart(mm,statdate),datepart(dd,statdate),
	MsgSrcType.Name 
	order by datepart(yy,statdate),datepart(mm,statdate),datepart(dd,statdate)"
	$Results = Get-SQLDataSet $query $Database
	
	if(($Results -ne "") -and ($Results -ne $null))
	{
		$ColumnNames =  "LogSrcType","CountLogs","CountsIdentified","CountsArchived","CountsEvents","CountsOnline","CountsProcessed","CountsDedupe","CountsPercentage"
	
		for($i=0;$i -le ($Results.Count - 1);$i++){ 
			
			$Value = ""
			$measureMonth = ($Results[$i].Month).tostring() | Measure-Object -Character
			$countMonth = $measureMonth.Characters
			$measureDay = ($Results[$i].Days).tostring() | Measure-Object -Character
			$countDay = $measureDay.Characters
			if($countMonth -le 1) { $Month = "0" + ($Results[$i].Month).tostring() } 
			else { $Month = ($Results[$i].Month).tostring() }
			if($countDay -le 1) { $Day = "0" + ($Results[$i].Days).tostring() } 
			else { $Day = ($Results[$i].Days).tostring() }
			$Value = '"' + ($Results[$i].Year).tostring() + "-" + $Month + "-" + $Day + 'T00:00:00",'
	
			$ValueStringJason = $ValueStringJason + '"@timestamp":' + $Value
		
			foreach($Name in $ColumnNames)
			{
				$Value = Json-SB $Name ($Results[$i].($Name))
				if(($Value -ne "") -or ($Value -ne $null)) { $ValueStringJason = $ValueStringJason + $Value }
			}
			
			Add-Content ($LocalIO + "\Data\" + $Type + "\" + $OutPutFileNameJson) ('{"index":{"_index":"' + $Index + '","_type":"' + $Type +'"}}')
			Add-Content ($LocalIO + "\Data\" + $type + "\" + $OutPutFileNameJson) ($HeaderJsonNoTimeStamp + ', "keyType":"' + $Type + '",' + ($ValueStringJason.Substring(0,$ValueStringJason.Length-1)) + ' }')
			$ValueStringJason = "";
		}
		Write-Log "REPORT: Daily Dedupe Log Volume Report - PASSED"
	}
	else
	{
		Write-Log "WARNING: $HostInfoComputerName - Gathered No Daily Dedupe By Type Log Volume Report"
		Write-Log "REPORT: Daily Dedupe Log Volume Report - FAILED"
	}
	Write-Log "SUCCESS: Completed Gathering Daily Dedupe By Type Log Volume Report Data"
	#endregion
	
	##########################################################
	###		SQL Job History (Event Manger)	               ###
	##########################################################
	#region
	$TypeFullName = "SQL Job History"
	Write-Log "SUCCESS: Started Gathering SQL Job History Data"
	$Database = "Master"
	$Type = "SQLJobHistory"
	if(!(Test-Path ($LocalIO + "\Data\" + $Type))) { mkdir ($LocalIO + "\Data\" + $Type)}
	if(!(Test-Path ($LocalIO + "\Data\" + $Type + "\" + $OutputFileNameJson))){New-Item ($LocalIO + "\Data\" + $Type + "\" + $OutputFileNameJson) -type file}
	
	$query = "SELECT j.job_id as JobID, j.name as Name, j.enabled as Enabled, jh.run_status as RunStatus, jh.message as Message, jh.run_date as RunDate, jh.step_name as StepName, jh.run_time as RunTime from msdb.dbo.sysjobs j inner join msdb.dbo.sysjobhistory jh on j.job_id = jh.job_id order by jh.run_date desc"
	$Results = Get-SQLDataSet $query "Master"
	
	if(DataRow-ToJson $Results $Type $HeaderJson) {
		Write-Log "REPORT: SQL Job History - PASSED"
		Write-Log "SUCCESS: Completed Gathering $TypeFullName Data"
		}
	else {
		Write-Log "WARNING: $HostInfoComputerName - Gathered NO $TypeFullName Data"
		Write-Log "REPORT: SQL Job History - FAILED"
	}
	#endregion
	
	##########################################################
	###		RBP Configuration (Event Manger)               ###
	##########################################################
	#region
	Write-Log "SUCCESS: Started Gathering RBP Configuation Data"
	$TypeFullName = "RBP Configuration"
	$Database = "LogRhythmEMDB"
	$Type = "RBPConfiguration"
	if(!(Test-Path ($LocalIO + "\Data\" + $Type))) { mkdir ($LocalIO + "\Data\" + $Type)}
	if(!(Test-Path ($LocalIO + "\Data\" + $Type + "\" + $OutputFileNameJson))){New-Item ($LocalIO + "\Data\" + $Type + "\" + $OutputFileNameJson) -type file}
	
	$query = "SELECT [RBPConfigurationID]
      ,[CalculationType]
      ,[DestRiskLevelDefaultPrivateHost]
      ,[DestRiskLevelDefaultPublicHost]
      ,[DestRiskLevelWeight]
      ,[SourceThreatLevelDefaultPrivateHost]
      ,[SourceThreatLevelDefaultPublicHost]
      ,[SourceThreatLevelWeight]
      ,[EventRiskRatingWeight]
      ,[ClassRiskRatingWeight]
      ,[FalsePositiveProbabilityWeight]
      ,[RuleRiskRatingInfluencer]
      ,[ImpactedHostRiskRatingInfluencer]
      ,[DateUpdated]
  		FROM [LogRhythmEMDB].[dbo].[RBPConfiguration]"
  
	$Results = Get-SQLDataSet $query $Database
	
	if(DataRow-ToJson $Results $Type $HeaderJson) {
		Write-Log "REPORT: RBP Configuration - PASSED"
		Write-Log "SUCCESS: Completed Gathering $TypeFullName Data"
		}
	else {
		Write-Log "WARNING: $HostInfoComputerName - Gathered NO $TypeFullName Data"
		Write-Log "REPORT: RBP Configuration - FAILED"
	}
	#endregion
	
	##########################################################
	###		ARM Configuration (Event Manger)               ###
	##########################################################
	#region
	$TypeFullName = "ARM Configuration"
	Write-Log "SUCCESS: Started Gathering ARM Configuration Data"
	$Database = "LogRhythmEMDB"
	$Type = "ARMConfiguration"
	if(!(Test-Path ($LocalIO + "\Data\" + $Type))) { mkdir ($LocalIO + "\Data\" + $Type)}
	if(!(Test-Path ($LocalIO + "\Data\" + $Type + "\" + $OutputFileNameJson))){New-Item ($LocalIO + "\Data\" + $Type + "\" + $OutputFileNameJson) -type file}
	
	$query = "SELECT [ARMID]
		     ,[HostID]
		     ,[Status]
		     ,[AlarmingEngineMode]
		     ,[ReportingEngineMode]
		     ,[LogLevel]
		     ,[ProcessPriority]
		     ,[MaxServiceMemory_ARM]
		     ,[LastHeartbeat]
		     ,[AE_MaxAlarmQueueSize]
		     ,[AE_KBCacheTTL]
		     ,[AE_MaintenanceInterval]
		     ,[AE_EventAgeLimit]
		     ,[AE_MaxAssociatedEventsPerAlarm]
		     ,[AE_HeartbeatMonitorInterval]
		     ,[AE_GetEventsTimeout]
		     ,[AE_GetEventsMaxRecords]
		     ,[AE_AlarmInsertTimeout]
		     ,[SRE_MaxErrorsPerJobPackage]
		     ,[SRE_QueryCommandTimeout]
		     ,[SRE_ProcessingInterval]
		     ,[SRE_ProcessingWindow]
		     ,[SNMP_MaxQueueSize]
		     ,[SMTP_Server1]
		     ,[SMTP_Server2]
		     ,[SMTP_Server3]
		     ,[SMTP_BatchEmailInterval]
		     ,[SMTP_MaxQueueSize]
		     ,[SMTP_MaxLogsPerEmail]
		     ,[SMTP_MaxAlarmsPerBatchEmail]
		     ,[SMTP_MaxLogsPerBatchEmail]
		     ,[SMTP_MaxLogLength]
		     ,[SMTP_EmailFrom]
		     ,[DateUpdated]
		     ,[RecordStatus]
		     ,[SMTP_Server1Password]
		     ,[SMTP_Server2Password]
	         ,[SMTP_Server3Password]
	         ,[SMTP_Server1User]
		     ,[SMTP_Server2User]
		     ,[SMTP_Server3User]
	         ,[SMTP_Server1WindowsAuthentication]
	         ,[SMTP_Server2WindowsAuthentication]
	         ,[SMTP_Server3WindowsAuthentication]
		     ,[AutoRmdnPluginDir]
		     ,[ComponentPlatformID]
		     ,[SRE_SafeReportingMemoryPercentage]
		     ,[MaxServiceMemory_JobManager]
		     ,[ADSyncInterval]
		     ,[LogMartDBServer]
		     ,[AlarmURL]
		     FROM [LogRhythmEMDB].[dbo].[ARM]"
  
	$Results = Get-SQLDataSet $query $Database
	
	if(DataRow-ToJson $Results $Type $HeaderJson) {
		Write-Log "REPORT: ARM Configuration - PASSED"
		Write-Log "SUCCESS: Completed Gathering $TypeFullName Data"
		}
	else {
		Write-Log "WARNING: $HostInfoComputerName - Gathered NO $TypeFullName Data"
		Write-Log "REPORT: ARM Configuration - FAILED"
	}
	#endregion
	
	#endregion
	
	###############################
	###   Registry Setting		###
	###############################
	#region
	
	#endregion
	
	###############################
	###			Perfmon			###
	###############################
	#region
	
#	Write-Log "SUCCESS: Started Gathering Perfmon Data"
#	
#	$ListPerfmonClasses = 	"LogRhythm ARM",
#							"LogRhythm System Monitor",
#							"LogicalDisk",
#							"Memory"
#	
#	foreach($PerfmonClass in $ListPerfmonClasses)
#	{
#		Write-Log "SUCCESS: Gathering $PerfmonClass Data"
#		$Type = $PerfmonClass
#		if(!(Test-Path ($LocalIO + "\Data\" + $Type))) { mkdir ($LocalIO + "\Data\" + $Type)}
#		if(!(Test-Path ($LocalIO + "\Data\" + $Type + "\" + $OutputFileNameJson))){New-Item ($LocalIO + "\Data\" + $Type + "\" + $OutputFileNameJson) -type file}
#		$ListCounterNames = Get-Counter -ListSet $PerfmonClass | Select-Object -ExpandProperty Counter
#
#		foreach($CounterName in $ListCounterNames)
#		{
#			$ListSampleSets = Get-Counter -Counter $CounterName | Select-Object -ExpandProperty CounterSamples | Select *
#
#			if($HostInfoComputerName) { $ValueStringJason = $ValueStringJason + ' "HostName":"' + $HostInfoComputerName + '",' }
#			if($HostInfoIPAddress) { $ValueStringJason = $ValueStringJason + ' "IpAddress":"' + $HostInfoIPAddress + '",' }
#			
#			$Value = Json-SB "CounterName" $CounterName
#			if(($Value -ne "") -or ($Value -ne $null)) { $ValueStringJason = $ValueStringJason + $Value }
#			
#			foreach($Sample in $ListSampleSets)
#			{
#				$NoteProperties = $Sample | get-member | Where-Object {$_.MemberType -match "NoteProperty"}
#				foreach($NoteProperty in $NoteProperties)
#				{
#					$Value = Json-SB $NoteProperty.Name $Sample.($NoteProperty.Name) 
#					if(($Value -ne "") -or ($Value -ne $null)) { $ValueStringJason = $ValueStringJason + $Value }
#				}
#				Add-Content ($LocalIO + "\Data\" + $Type + "\" + $OutPutFileNameJson) ('{"index":{"_index":"' + $Index + '","_type":"' + $Type +'"}}')
#				Add-Content ($LocalIO + "\Data\" + $type + "\" + $OutPutFileNameJson) ($HeaderJsonNoTimeStamp + ',' + ($ValueStringJason.Substring(0,$ValueStringJason.Length-1)) + ' }')
#				$ValueStringJason = "";
#			}	
#		}	
#	}
#	Write-Log "REPORT: Performance Monitor."
#	Write-Log "SUCCESS: Completed Gathering Perfmon Data"
	
	#endregion
	
	###############################
	###			Logs			###
	###############################
	#region
	Write-Log "SUCCESS: Started Gathering Log Data"
	
	# ERRORLOG
	Write-Log "SUCCESS: Gathering ERROR Log Data"
	Copy-Files 'C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\LOG\ERRORLOG' 'ERRORLOG'
	
	# lrjobmgr (job)
	Write-Log "SUCCESS: Gathering LRJobMGR Log Data"
	$JobManagerlrjobmgr = Get-ItemProperty -Path "HKLM:\SOFTWARE\LogRhythm\lrjobmgr"
	
	if(Test-Path ($JobManagerlrjobmgr.CONFIGPATH + 'logs\lrjobmgr.log'))
	{
		Copy-Files ($JobManagerlrjobmgr.CONFIGPATH + 'logs\lrjobmgr.log') 'LRJobMGR'
		Write-Log "INFO: Copy File: " + ($JobManagerlrjobmgr.CONFIGPATH + 'logs\lrjobmgr.log')
	}
	else
	{
		if(Test-Path "C:\Program Files\LogRhythm\LogRhythm Job Manager\logs\lrjobmgr.log")
		{
			Copy-Files "C:\Program Files\LogRhythm\LogRhythm Job Manager\logs\lrjobmgr.log" 'LRJobMgr'
			Write-Log "INFO: Copy File: C:\Program Files\LogRhythm\LogRhythm Job Manager\logs\lrjobmgr.log"
		}
		else { Write-Log "ERROR: Could not copy lrjobmgr.log" }		
	}
	
	# scarm (arm)
	Write-Log "SUCCESS: Gathering SCARM Log Data"
	$ARMscarm = Get-ItemProperty -Path "HKLM:\SOFTWARE\LogRhythm\scarm"
	
	if(Test-Path ($ARMscarm.CONFIGPATH + 'logs\scarm.log'))
	{
		Copy-Files ($ARMscarm.CONFIGPATH + 'logs\scarm.log') 'SCARM'
		Write-Log "INFO: Copy File: " + ($ARMscarm.CONFIGPATH + 'logs\scarm.log')
	}
	else
	{
		if(Test-Path "C:\Program Files\LogRhythm\LogRhythm Alarming and Response Manager\logs\scarm.log")
		{
			Copy-Files "C:\Program Files\LogRhythm\LogRhythm Alarming and Response Manager\logs\scarm.log" 'SCARM'
			Write-Log "INFO: Copy File: C:\Program Files\LogRhythm\LogRhythm Alarming and Response Manager\logs\scarm.log"
		}
		else { Write-Log "ERROR: Could not copy scarm.log" }		
	}

	# scsm (Agent)
	Write-Log "SUCCESS: Gathering SCSM Log Data"
	$Mediatorscsm = Get-ItemProperty -Path "HKLM:\SOFTWARE\LogRhythm\scsm"
	
	if(Test-Path ($Mediatorscsm.CONFIGPATH + 'logs\scsm.log'))
	{
		Copy-Files ($Mediatorscsm.CONFIGPATH + 'logs\scsm.log') 'SCSM'
		Write-Log "INFO: Copy File: " + ($Mediatorscsm.CONFIGPATH + 'logs\scsm.log')
	}
	else
	{
		if(Test-Path "C:\Program Files\LogRhythm\LogRhythm Mediator Server\logs\scsm.log")
		{
			Copy-Files "C:\Program Files\LogRhythm\LogRhythm Mediator Server\logs\scsm.log" 'SCSM'
			Write-Log "INFO: Copy File: C:\Program Files\LogRhythm\LogRhythm Mediator Server\logs\scsm.log"
		}
		else { Write-Log "ERROR: Could not copy scmpe.log" }		
	}
	
	### System Monitor Logs ###
		
	$LogRhythmSystemMonitorLogsList = "filemon",
							   		  "regmon",
									  "rtfim"
							   
	foreach($LogRhythmSystemMonitorLog in $LogRhythmSystemMonitorLogsList)
	{
		Write-Log "SUCCESS: Gathering $LogRhythmSystemMonitorLog Logs"
		Copy-Files ('C:\Program Files\LogRhythm\LogRhythm System Monitor\logs\' + $LogRhythmSystemMonitorLog + '.log') $LogRhythmSystemMonitorLog
	}
	
	Write-Log "SUCCESS: Completed Gathering $HostInfoComputerName Data"
	#endregion
	
	$sw.stop() #Stop the stop watch
	Write-Log "REPORT: Logs - PASSED"
	$SWMinutes = $sw.Elapsed.Minutes
	$SWSeconds = $sw.Elapsed.Seconds
	Write-Log "REPORT: Step Completed: - $SWMinutes Minutes $SWSeconds Seconds"
	Write-Log "REPORT: "
}


###################################
###		Main					###
###################################
function Main()
{
	Run-OneTime 
}

Main
