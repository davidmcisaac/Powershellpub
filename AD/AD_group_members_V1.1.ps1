<#PSScriptInfo
.DESCRIPTION 
AD Count of members per group.
A member is counted as either a user or group
.VERSION 1.1

.AUTHOR David McIsaac

.COMPANYNAME 

.COPYRIGHT 2018

.EXTERNALSCRIPTDEPENDENCIES 
 Tested on Windows Server 2012 and 2012 R2
 Requires AD module to be avaliable. 
.RELEASENOTES
 .Change Log From V1.0 to V1.1
 Implemented log path variable
#>
$script:logpath = "C:\ADlogs\"
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
function Get-GroupStat {
    $maxmember = 5 #Set max number of members per group
    $adgroups = Get-ADGroup -Filter * -Properties members,description|Select-Object Name,SamAccountName,description,GroupScope,GroupCategory,members
    for ($i=0; $i -le $maxmember; $i++) 
        {#loop until maxmember count is reached
            $currentgroup= $adgroups|Where-Object {$_.members.count -eq $i}
            $currentgroup|export-csv -NoTypeInformation ($logpath + $i + "_AD Group Members.csv")
        }
 }