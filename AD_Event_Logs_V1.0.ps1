<#PSScriptInfo
.DESCRIPTION 
 Gather event logs whilst logged onto domain controller
 Only collect Warning and Error logs within last 7 days
.VERSION 1.0

.AUTHOR David McIsaac

.COMPANYNAME 

.COPYRIGHT 2017

.EXTERNALSCRIPTDEPENDENCIES 

.RELEASENOTES
 Tested on Windows Server 2012 and 2012 R2
#>
$Daterange = 7
$Todaysdate = get-date
$Startdate = $Todaysdate.adddays(-$Daterange)
$outpath = "C:\logs\"
$createpath = Test-path $outpath
if ($createpath -eq $true)
    {
    write-host "'Continue'"
    }
elseif ($createpath -eq $false)
    {
    new-item -path $outpath -ItemType Directory
    }
$EVentrytype = "Error","Warning"
$EVdata = @(@{label="Logged";expression = {[string]$_.timewritten}},"EntryType","Source","EventID",@{label="Description";expression = {[string]$_.message}})
$EVlogs = "Application","System","Active Directory Web Services","DFS Replication","Directory Service","DNS Server"

foreach ($elog in $EVlogs)
    {
    Get-EventLog -LogName $elog -After $Startdate -EntryType $EVentrytype|select-object $EVdata|export-csv ($outpath + "EVLog_" + $elog + ".csv")
    start-sleep -s 20
    }