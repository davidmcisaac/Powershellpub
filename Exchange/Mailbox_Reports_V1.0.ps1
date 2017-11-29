<#PSScriptInfo
.DESCRIPTION 
 A collection of different mailbox reports
 Reports:
 Distribution Groups and members
 Shared mailboxes and Access rights for members.
.VERSION 1.0

.AUTHOR David McIsaac

.COMPANYNAME 

.COPYRIGHT 2017

.EXTERNALSCRIPTDEPENDENCIES 
 Requires Exchange Powershell Module
.RELEASENOTES
 Tested on Exchange 2013
#>
$excserver = "exchange-server"
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://$excserver/PowerShell/ -Authentication Kerberos
Import-PSSession $Session -ea 0 -AllowClobber
#Distribution Group members
$distgrp_report =@()
$distgrp = Get-DistributionGroup

foreach ($grp in $distgrp)
    {
    $distgrp_report += Get-DistributionGroupMember -Identity $grp.Name|Select-Object @{label="Distribution Group";exp={$grp.name}},@{label="PrimarySmtpAddress";exp={$grp.PrimarySmtpAddress}},name,RecipientType
    }

$distgrp_report| export-csv C:\DistributionGroups_with_members.csv -NoTypeInformation
#shared mailboxes
$sharedmbx_report =@()
$sharedmvx_sendas =@()
$sharedmbx = Get-Mailbox -RecipientTypeDetails sharedmailbox

foreach ($mbx in $sharedmbx)
    {
    $sharedmbx_report += Get-MailboxPermission -Identity $mbx.name|Where-Object {$_.isinherited -eq $false -and $_.user -ne "NT AUTHORITY\SELF"}|select-object @{label="Shared Mailbox";exp={$mbx.name}},@{label="PrimarySmtpAddress";exp={$mbx.PrimarySmtpAddress}},@{label= "Delegated User";exp={$_.user}},AccessRights
    $sharedmvx_sendas += Get-ADPermission -Identity $mbx.name |where-object {$_.isinherited -eq $false  -and $_.ExtendedRights -like "*send-as*" -and $_.User -ne "NT AUTHORITY\SELF"}|select-object @{label="Shared Mailbox";exp={$mbx.name}},@{label="PrimarySmtpAddress";exp={$mbx.PrimarySmtpAddress}},@{label= "Delegated User";exp={$_.user}},extendedrights
    }

$sharedmbx_report| export-csv C:\sharedmailboxes_with_members.csv -NoTypeInformation
$sharedmvx_sendas| export-csv C:\sharedmailboxes_with_members_sendas.csv -NoTypeInformation