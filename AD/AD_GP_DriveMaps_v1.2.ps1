<#PSScriptInfo
.DESCRIPTION 
Obtain all Group policie objects in domain and check for GPP drive mappings
.VERSION 1.2
Implemented log path variable
.AUTHOR David McIsaac

.COMPANYNAME 

.COPYRIGHT 2017

.EXTERNALSCRIPTDEPENDENCIES 
Requires AD module to be avaliable. 
.RELEASENOTES
Tested on Windows Server 2012 and 2012 R2
 Read XML guidance from https://blogs.msdn.microsoft.com/kalleb/2008/07/19/using-powershell-to-read-xml-files/

 .Change log from V1.1 to V1.2
 Implemented log path variable
#>                          
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
$gpoxml=@();$dmreport=@()#create empty array
$gpoall = Get-GPO -All|Select-Object DisplayName,ID,DomainName
$currentdomain = $GPOall[0]|Select-Object Domainname
$gpostore = "\\"+($currentdomain.DomainName)+"\SYSVOL\"+($currentdomain.DomainName)+"\Policies\"
foreach ($gpo in $gpoall)
    {#loop through each gpo
        if ((Test-Path (($gpostore)+"{"+($gpo.ID)+"}\User\Preferences\Drives\Drives.xml")) -eq $true)
        {#check if drive maps have been defined
            [xml]$gpoxml = Get-Content (($gpostore)+"{"+($gpo.ID)+"}\User\Preferences\Drives\Drives.xml")
            $drivemap=@()#create empty array
            foreach ( $drivemap in $gpoxml.Drives.Drive )             
                {#process each gpo
                    $dmreport += $drivemap|Select-Object @{name="GPOName";expression={$gpo.DisplayName}},@{name="Drive Letter";expression={$drivemap.Properties.letter}},@{name="Action";expression={$drivemap.Properties.action -creplace "D","Delete" -creplace "U","Update" -creplace "R","Replace" -creplace "C","Create" }},@{name="Location";expression={$drivemap.Properties.path}},@{name="Enabled";expression={$drivemap.Properties.persistent -replace "1","True" -replace "0","False" }},@{name="Label";expression={$drivemap.Properties.label}},@{name="Target AD Group";expression={[string]$drivemap.Filters.FilterGroup.name}},@{name="OU Filter";expression={[string]$drivemap.Filters.FilterOrgUnit.name}},@{name="User Filter";expression={[string]$drivemap.Filters.filteruser.name}},@{name="Last Modified";expression={$drivemap.changed}}
                }
        }
    }
$dmreport|export-csv -NoTypeInformation ($logpath + "AD_GP_DriveMap_Report_V1.2.csv")