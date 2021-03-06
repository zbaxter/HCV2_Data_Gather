##########################################################
###		Data Indexer Health Check 					   ###
##########################################################

# Start DEV
#	function Write-Log($Message) { }#Write-Output $Message };
#
#	$SQLUserName= "sa"
#	$SQLPassword = "logrhythm!1"
#	$WindowsUserName = "logrhythm"
#	$WindowsPassword = "logrhythm!1"
#	$HostInfoIPAddress = "10.7.13.100"
#	$LocalIO = "C:\Temp\DGv1"
#	
# End DEV

function Test-WMI_Connection(){
	Write-Log "Info: Testing WMI Connection"
	if($ServerIPAddress){ Write-Log "INFO: Host IP Address: $ServerIPAddress" }
	else { Write-Log "ERROR: No Host IP Address" }
	if($cred) { Write-Log "INFO: Credentials Provided" }
	else { Write-Log "WARNING: Credentials Not Provided" }
	$ConnectionType = 0  # 0 - Not Connected, 1 - Connected with provided Creds, 2 - Connects with system Creds
	try{
		$wmi = gwmi win32_bios -ComputerName $ServerIPAddress -ErrorAction SilentlyContinue 
		if($wmi){ 
		$ConnectionType = 2
		Write-Log "SUCCESS: Connection Made With System Credentials"
		}
	}
	catch{
		$wmi = gwmi win32_bios -ComputerName $ServerIPAddress -Credential $cred -ErrorAction SilentlyContinue 
		if($wmi){ 
		$ConnectionType = 1
		Write-Log "SUCCESS: Connection Made With Provided Credentials"
		}
	}
	if($ConnectionType -eq 0)
	{
		$ConnectionType = 0
	}
	return $ConnectionType
}

function Gather-InfluxData($Server, $TotalTime, $Interval, $ServerName)
{
	$StartingLocation = pwd
	cd ($LocalIO + "\Curl")
	$InfluxFileName = (($LocalIO + '\Data\InfluxData\' + $keyCustomerName + "." + 'Measurements' + "." + (Get-Date -Format "MMddyyyy").ToString() + '.csv').replace(" ","_"))
	if(Test-Path ($LocalIO + "\Curl\curl.exe"))
	{
		$Type = "InfluxData"
		if(!(Test-Path ($LocalIO + "\Data\" + $Type))) { mkdir ($LocalIO + "\Data\" + $Type)}
		$commandtorun = 'curl -G "http://' + $Server + ':8086/query" --data-urlencode "db=stats" --data-urlencode "q=SHOW MEASUREMENTS" -o ' + $InfluxFileName
		$CurlResults = cmd /c $commandtorun 2>&1 | Out-Null
	}
	
	if(Test-Path ($InfluxFileName))
	{
		if((Get-Content ($InfluxFileName)).Contains('{"results":[{}]}'))
		{
			Write-Log "INFO: $InfluxFileName is not the primary Influx Database."
		}
		elseif((Get-Content ($InfluxFileName)).Contains('{"results":[{"series":[{"name":"measurements","columns":["name"],"values":['))
		{
			(Get-Content $InfluxFileName) -replace [regex]::escape('{"results":[{"series":[{"name":"measurements","columns":["name"],"values":['),'' | Set-Content ($InfluxFileName)
			(Get-Content $InfluxFileName) -replace [regex]::escape('['),'' | Set-Content ($InfluxFileName)
			(Get-Content $InfluxFileName) -replace [regex]::escape(']'),'' | Set-Content ($InfluxFileName)
			(Get-Content $InfluxFileName) -replace [regex]::escape('}'),'' | Set-Content ($InfluxFileName)
			(Get-Content $InfluxFileName) -replace [regex]::escape('"'),'' | Set-Content ($InfluxFileName)
		
			$Measurements = (Get-Content ($InfluxFileName)) -split ","
		
			if($Measurements)
			{
				foreach($Measurement in $Measurements)
				{
					$commandtorun = 'curl -G "http://' + $Server + ':8086/query?pretty=true" --data-urlencode "db=stats" --data-urlencode "q=SELECT count(value) AS Value from \"' + $Measurement + '\"  WHERE time > now() - ' + $TotalTime + ' group by time(' + $Interval + '), host, service fill(null)" -o ' + (($LocalIO + '\Data\InfluxData\' + $keyCustomerName + "." + $Measurement + "." + (Get-Date -Format "MMddyyyy").ToString() + '.json').replace(" ","_"))  
					$CurlResults = cmd /c $commandtorun 2>&1 | Out-Null
					Write-Log ("SUCCESS: Gathering " + $Measurement.tostring() + " from InfluxDB")
				}
			}
		}
		else
		{
		
		}
	}
	cd $StartingLocation
}

	##########################################################
	###		Global										   ###
	##########################################################
	
 	$sw = [Diagnostics.Stopwatch]::StartNew()
	$sw.Start() # Start Stopwatch
	
	if(!$WindowsUserName) { 
		Write-Log "ERROR: You need a Windows User Name"
		throw 
	}
	if(!$WindowsPassword) {
		Write-Log "ERROR: You need a Windows Password"
		throw 
	}
	
	$TmpDate = Get-Date
	$DateTime = ($TmpDate.ToString("yyyy-MM-dd HH:mm:ss").split(' ')[0] + "T" + $TmpDate.ToString("yyyy-MM-dd HH:mm:ss").split(' ')[1])
	
	$secstr = New-Object -TypeName System.Security.SecureString
	$WindowsPassword.ToCharArray() | ForEach-Object {$secstr.AppendChar($_)}
	$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $WindowsUserName, $secstr
	$networkCred = $cred.GetNetworkCredential()
	
	[xml]$XMLDeploymentInfo = Get-Content ($LocalIO + "\Data\DeploymentInfo.xml")
	$keyDateGatherDateTime = $XMLDeploymentInfo.Deployment.keyDateGatherDateTime
	$keyCustomerName = $XMLDeploymentInfo.Deployment.keyCustomerName
	$keyLicenseID = $XMLDeploymentInfo.Deployment.keyLicenseID
	$keyVersion = $XMLDeploymentInfo.Deployment.keyVersion
	$LogRhythmMajorVersion = $XMLDeploymentInfo.Deployment.LogRhythmMajorVersion
	$LogRhythmMinorVersion = $XMLDeploymentInfo.Deployment.LogRhythmMinorVersion
	
	$DXServers = $XMLDeploymentInfo.Deployment.DXServers
	
	if($keyCustomerName -and $keyLicenseID -and $keyDateGatherDateTime)
	{
		$OutputFileNameJson = $keyLicenseID.ToString() + "." + $HostInfoComputerName + "." + (Get-Date -Format "MMddyyyy").ToString() + ".json"  
		$OutputFileNameTXT = $keyLicenseID.ToString() + "." + $HostInfoComputerName + "." + (Get-Date -Format "MMddyyyy").ToString() + ".txt"  
		$OutputFileNameLog = $keyLicenseID.ToString() + "." + $HostInfoComputerName + "." + (Get-Date -Format "MMddyyyy").ToString() + ".log"  
	}
	else
	{
		Write-Log "ERROR: Customer Information Found From Deployment [XML]"
		throw 
	}
	
	$HeaderJson =  '{"@timestamp":"' + $DateTime + '","keyGatherDateTime":"' + $keyDateGatherDateTime + '","keyCustomerName":"' + $keyCustomerName + '","keyLicenseID":' + $keyLicenseID.ToString() + ',"keyHostName":"' + $HostInfoComputerName + '","keyVersion":"7.1.3"'
	$HeaderJsonNoTimeStamp =  '{"keyGatherDateTime":"' + $keyDateGatherDateTime + '","keyCustomerName":"' + $keyCustomerName + '","keyLicenseID":' + $keyLicenseID.ToString() + ',"keyHostName":"' + $HostInfoComputerName + '","keyVersion":"7.1.3"'
	
	Write-Log "REPORT: ------------------------------------------"
	Write-Log "REPORT: Data Indexer"
	Write-Log "REPORT: ------------------------------------------"
	Write-Log "REPORT: "
	
	
	##########################################################
	###		InfluxDB Datat Gather						   ###
	##########################################################

	if($DXServers)
	{
		foreach($DXServer in $DXServers)
		{
			$ServerIPAddress = $DXServer.DX_IPAddress
			$ServerName = $DXServer.DX_HostName

			if($ServerIPAddress)
			{
				##########################################################
				###		InfluxDB Datat Gather						   ###
				##########################################################

				Gather-InfluxData $ServerIPAddress "24h" "15m" $ServerName
				
				##########################################################
				###		SSH Client									   ###
				##########################################################
			
				$targetondisk = "$($env:USERPROFILE)\Documents\WindowsPowerShell\Modules"
				if(!(Test-Path "$($env:USERPROFILE)\Documents\WindowsPowerShell\Modules"))
				{
					New-Item -ItemType Directory -Force -Path $targetondisk | out-null
				}
			
				if(!(Test-Path "$($env:USERPROFILE)\Documents\WindowsPowerShell\Modules\Posh-SSH"))
				{
					Copy-Item ($LocalIO + "\Posh-SSH") ("$($env:USERPROFILE)\Documents\WindowsPowerShell\Modules") -Recurse
				}

				Import-Module -Name posh-ssh
		
				# Kill any open sessions
				$AllSessions = Get-SSHSession
		
#				if(($AllSessions.count -ne 0) -or ($AllSessions -ne $null))
#				{
#					foreach($Session in $AllSessions)
#					{
#						Remove-SSHSession -Index $Session.SessionID
#					}
#				}
		
				try { $SSHConnection = New-SSHSession -ComputerName $ServerIPAddress -Credential $cred -AcceptKey  }
				catch {} 
		
				if($SSHConnection.connected -eq "True")
				{
				
				##########################################################
				###		Data Indexer Log Files						   ###
				##########################################################
			
				$RemoteFiles = "/var/log/elasticsearch/logrhythm_index_indexing_slowlog.log",
							   "/var/log/elasticsearch/logrhythm_index_search_slowlog.log",
							   "/var/log/elasticsearch/logrhythm.log",
							   "/var/log/grafana/grafana.log",
							   "/var/log/grafana/xorm.log",
							   "/var/log/nginx/access.log",
							   "/var/log/nginx/allconf.access.log",
							   "/var/log/nginx/allconf.error.log",
							   "/var/log/nginx/consul.access.log",
							   "/var/log/nginx/consul.error.log",
							   "/var/log/nginx/error.log",
							   "/var/log/nginx/grafana.access.log",
							   "/var/log/nginx/grafana.error.log",
							   "/var/log/persistent/allconf.log",
							   "/var/log/persistent/ansible.log",
							   "/var/log/persistent/anubis.log",
							   "/var/log/persistent/bulldozer.log",
							   "/var/log/persistent/carpenter.log",
							   "/var/log/persistent/columbo.log",
							   "/var/log/persistent/conductor.log",
							   "/var/log/persistent/configserver.log",
							   "/var/log/persistent/godispatch.log",
							   "/var/log/persistent/gomaintain.log",
							   "/var/log/persistent/heartthrob.log",
							   "/var/log/persistent/logrhythm-cluster-install.sh.log",
							   "/var/log/persistent/logrhythm-node-install.sh.log",
							   "/var/log/persistent/vitals.log"
							   
				foreach($RemoteFile in $RemoteFiles)
				{
					$Type = $RemoteFile.split("/")[3]
					$FileName = ($keyLicenseID.ToString() + "." + $ServerName + "." + (Get-Date -Format "MMddyyyy").ToString() + "." + $RemoteFile.split("/")[4])
					if(!(Test-Path ($LocalIO + "\Data\" + $Type))) { mkdir ($LocalIO + "\Data\" + $Type)}
					try{
					Get-SCPFile -LocalFile ($LocalIO + "\Data\" + $Type + "\" + $FileName) -RemoteFile $RemoteFile -Credential $cred -ComputerName $ServerIPAddress | Out-Null
					If ((Get-Content ($LocalIO + "\Data\" + $Type + "\" + $FileName)) -eq $Null) {
						Remove-Item -Path ($LocalIO + "\Data\" + $Type + "\" + $FileName)
					}
						Write-Log ("SUCCESS: Gathered " + $RemoteFile.split("/")[4] + " Logs from $IndexDP_HostName")
					}
					catch{}
					Write-Log "REPORT: Logs - PASSED"
				}
				
				Remove-SSHSession -Index 0 
				}
				else
				{
					Write-Log "WARNING: Unable to collect logs from $ServerName at this time."
				}
			}
		}
	}

	$sw.stop() #Stop the stop watch
	Write-Log "REPORT: Logs - PASSED"
	$SWMinutes = $sw.Elapsed.Minutes
	$SWSeconds = $sw.Elapsed.Seconds
	Write-Log "REPORT: Step Completed: - $SWMinutes Minutes $SWSeconds Seconds"
	Write-Log "REPORT: "