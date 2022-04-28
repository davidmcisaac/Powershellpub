<#PSScriptInfo
.DESCRIPTION 
 Install RSAT tools for Windows 10 2004 and later
 Subset of RSAT tools to be installed
 Active Directory 
 DNS
 File Services
 DNS
 Server Manager
 Group Policy
 Run Get-WindowsCapability -Online -Name "RSAT.*" to list all RSAT tools and filters can be added to include or exclude components. 
.VERSION 1.0

.AUTHOR David McIsaac

.COMPANYNAME 

.COPYRIGHT 2022

.EXTERNALSCRIPTDEPENDENCIES 
Download Feature on Demand ISO for Windows 10 version 2004 and extract to shared location. 
Grant authenticated users read-only share permissions to the FOD share
#>

$FODAD = Get-WindowsCapability -Online -Name "RSAT.*" | Where-Object {$_.Name -like "Rsat.ActiveDirectory*" -OR $_.Name -like "Rsat.FileServices*" -OR $_.Name -like "Rsat.Dns*" -OR $_.Name -like "Rsat.GroupPolicy*" -OR $_.Name -like "Rsat.ServerManager*" -AND $_.State -eq "NotPresent" } 

foreach ($fod in $FODAD)#install AD and server manager rsat tools 
{Add-WindowsCapability -Name $fod.name -Online -Source \\servername\FOD_Win10_2004$ -LimitAccess
}
