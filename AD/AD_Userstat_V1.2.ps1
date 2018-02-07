<#PSScriptInfo
.DESCRIPTION 
Report AD User Account audit
.VERSION 1.2

.AUTHOR David McIsaac

.COMPANYNAME 

.COPYRIGHT 2017

.EXTERNALSCRIPTDEPENDENCIES 
 Tested on Windows Server 2012 and 2012 R2
 Requires AD module to be avaliable. 
.RELEASENOTES
 A bit of help from these posts 
 #ref https://technet.microsoft.com/en-us/library/dd378867(v=ws.10).aspx
 #ref https://blogs.technet.microsoft.com/askds/2009/04/15/the-lastlogontimestamp-attribute-what-it-was-designed-for-and-how-it-works/

 .Change Log From V1.0 to V1.1
 Added Password Never Expires
 Added passwordnotrequired
 .Change log from V1.1 to V1.2
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
function Get-ADUserstat
{write-host "Processing..." -ForegroundColor Cyan
    $script:ADuserReport=@();$script:ADaccounts=@()
    $script:ADaccounts = get-aduser -Filter * -Properties LastLogondate,lastLogontimestamp,PasswordLastSet,PasswordNotRequired|Select-Object Name,Samaccountname,UserPrincipalName,lastLogontimestamp, LastLogonDate,PasswordLastSet,PasswordNotRequired,Enabled;Write-Host "Number of AD Users to Process -"$ADaccounts.count -ForegroundColor yellow
    $ADacountsenabled = $ADaccounts|Where-Object {$_.enabled -eq $true};Write-Host "Number of AD Users Enabled -" $ADacountsenabled.count -ForegroundColor Green
    $ADacountsdisabled = $ADaccounts|Where-Object {$_.enabled -eq $false};Write-Host "Number of AD Users Disabled -" $ADacountsdisabled.count -ForegroundColor Red
    foreach ($user in $script:ADaccounts)
    {
        $time = 0
        if($user.lastLogontimestamp -gt $time) 
        {
            $time = $user.lastLogontimestamp 
        }
    $dt = [DateTime]::FromFileTime($time)
    $script:ADuserReport +=$user|Select-Object Name,Samaccountname,UserPrincipalName,@{name="lastLogontimestamp";exp={$dt}}, LastLogonDate,PasswordLastSet,PasswordNotRequired,Enabled
    }
    $script:ADuserReport|Sort-Object Name|Export-Csv -NoTypeInformation ($logpath +"ADUserStatusReport_V1.2.csv")
    Write-Host "Active Directory User account status report exported to" ($logpath +"ADUserStatusReport_V1.2.csv")
    write-host "End of Script..." -ForegroundColor Cyan
 }
 Get-ADUserstat
