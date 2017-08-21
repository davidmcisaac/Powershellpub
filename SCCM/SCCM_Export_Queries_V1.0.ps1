<#PSScriptInfo
.DESCRIPTION 
Export Queries in SCCM 
.VERSION 1.0

.AUTHOR David McIsaac

.COMPANYNAME 

.COPYRIGHT 2017

.EXTERNALSCRIPTDEPENDENCIES 
Requires SCCM powershell module
.RELEASENOTES
 
#>
Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1" # Import the ConfigurationManager.psd1 module 

$pssccm = @();$sccm_site = @();$scquery=@()
$sccm_site = Get-PSDrive|Where-Object {$_.Provider -match 'CMSite'}|Select-Object Name,sitecode
$pssccm = ($sccm_site.Name + ":")
Set-Location $pssccm 
$scquery =get-cmquery|Select-Object Comments,Expression,LimitToCollectionID,Name,TargetClassName
$scquery|Export-Csv C:\SCCM_export_queries_V1.0.csv -NoTypeInformation