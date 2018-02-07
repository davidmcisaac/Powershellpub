<#PSScriptInfo
.DESCRIPTION 
 Gather event logs whilst logged onto domain controller
 Only collect Warning and Error logs within last 14 days
.VERSION 1.1

.AUTHOR David McIsaac

.COMPANYNAME 

.COPYRIGHT 2017

.EXTERNALSCRIPTDEPENDENCIES 

.RELEASENOTES
 Tested on Windows Server 2012 and 2012 R2

.Change log from V1.0 to V1.1
 Implemented log path variable
#>
$Daterange = 14
$Todaysdate = get-date
$Startdate = $Todaysdate.adddays(-$Daterange)
$logpath = "C:\ADlogs\"
$createpath = Test-path $logpath
if ($createpath -eq $true)
    {
    write-host "Logs exporting to" $logpath
    }
elseif ($createpath -eq $false)
    {
    new-item -path $logpath -ItemType Directory
    write-host "Created log path and exporting to" $logpath
    }
$EVentrytype = "Error","Warning"
$EVdata = @(@{label="Logged";expression = {[string]$_.timewritten}},"EntryType","Source","EventID",@{label="Description";expression = {[string]$_.message}})
$EVlogs = "Application","System","Active Directory Web Services","DFS Replication","Directory Service","DNS Server"

foreach ($elog in $EVlogs)
    {
    Get-EventLog -LogName $elog -After $Startdate -EntryType $EVentrytype|select-object $EVdata|export-csv ($logpath + "EVLog_" + $elog + ".csv") -Verbose
    start-sleep -s 20
    }