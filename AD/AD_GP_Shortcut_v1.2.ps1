<#PSScriptInfo
.DESCRIPTION 
Obtain all Group policie objects in domain and check for GPP shortcuts
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
$gpoxml=@();$screport=@()#create empty array
$gpoall = Get-GPO -All|Select-Object DisplayName,ID,DomainName
$currentdomain = $GPOall[0]|Select-Object Domainname
$gpostore = "\\"+($currentdomain.DomainName)+"\SYSVOL\"+($currentdomain.DomainName)+"\Policies\"
foreach ($gpo in $gpoall)
    {#loop through each gpo
        if ((Test-Path (($gpostore)+"{"+($gpo.ID)+"}\User\Preferences\shortcuts\shortcuts.xml")) -eq $true)
        {#check if shortcuts have been defined
            [xml]$gpoxml = Get-Content (($gpostore)+"{"+($gpo.ID)+"}\User\Preferences\shortcuts\shortcuts.xml")
            $shortcut=@()#create empty array
            foreach ( $shortcut in $gpoxml.Shortcuts.Shortcut )             
                {#process each gpo
                    $screport += $shortcut|Select-Object @{name="GPOName";expression={$gpo.DisplayName}},@{name="Target Type";expression={$shortcut.Properties.targettype}},@{name="Action";expression={$shortcut.Properties.action -creplace "D","Delete" -creplace "U","Update" -creplace "R","Replace" -creplace "C","Create" }},@{name="Target Path";expression={$shortcut.Properties.targetpath}},@{name="Shortcut Path";expression={$shortcut.Properties.shortcutpath}},@{name="Target AD User";expression={[string]$shortcut.Filters.FilterUser.name}},@{name="Target AD Group";expression={[string]$shortcut.Filters.FilterGroup.name}},@{name="Target OU";expression={[string]$shortcut.Filters.FilterOrgUnit.name}},@{name="Collection AD User";expression={[string]$shortcut.Filters.FilterCollection.FilterUser.name}},@{name="Collection AD Group";expression={[string]$shortcut.Filters.FilterCollection.FilterGroup.name}},@{name="Collection OU ";expression={[string]$shortcut.Filters.FilterCollection.Filterorgunit.name}},@{name="OS Filter";expression={[string]$shortcut.Filters.FilterOs.version}},@{name="Last Modified";expression={$shortcut.changed}}
                }
        }
    }
$screport|export-csv -NoTypeInformation ($logpath + "AD_GP_Shortcut_Report_V1.2.csv")