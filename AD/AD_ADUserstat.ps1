<#PSScriptInfo
.DESCRIPTION 
Report AD User Account audit
.VERSION 1.0

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
#>
function Get-ADUserstat
{write-host "Processing..." -ForegroundColor Cyan
    $logpath = "C:\temp\"
    $script:ADuserReport=@();$script:ADaccounts=@()
    $script:ADaccounts = get-aduser -Filter * -Properties LastLogondate,lastLogontimestamp,PasswordLastSet|Select-Object Name,Samaccountname,UserPrincipalName,lastLogontimestamp, LastLogonDate,PasswordLastSet,Enabled;Write-Host "Number of AD Users to Process -"$ADaccounts.count -ForegroundColor yellow
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
    $script:ADuserReport +=$user|Select-Object Name,Samaccountname,UserPrincipalName,@{name="lastLogontimestamp";exp={$dt}}, LastLogonDate,PasswordLastSet,Enabled
    }
    $script:ADuserReport|Sort-Object Name|Export-Csv -NoTypeInformation ($logpath +"ADUserStatusReport_V1.0.csv")
    Write-Host "Active Directory User account status report exported to" ($logpath +"ADUserStatusReport_V1.0.csv")
    write-host "End of Script..." -ForegroundColor Cyan
 }
 Get-ADUserstat
