<#PSScriptInfo
.DESCRIPTION 
 SCCM import computer list into collection from csv file

.VERSION 1.0

.AUTHOR David McIsaac

.COPYRIGHT 2016

.EXTERNALSCRIPTDEPENDENCIES 
 Requires SCCM powershell module

.RELEASENOTES
 Tested on SCCM 2012 R2
 #Sample CSV file in repository
#>
Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1" # Import the ConfigurationManager.psd1 module 
$pssccm = @();$sccm_site = @();$computers = @()

$sccm_site = Get-PSDrive|Where-Object {$_.Provider -match 'CMSite'}|select-object Name,sitecode
$pssccm = ($sccm_site.Name + ":")
Set-Location $pssccm

$computers = import-csv "C:\SCCM_computer_list_import_V1.0.csv"
$collection = "My Workstations Import"

foreach($client in $computers) 
    {
    if ((get-cmdevice -Name $client.computername -ErrorAction SilentlyContinue) -eq $null )
        {
        write-host "not registered in SCCM" $client.Computername -ForegroundColor Magenta
        }
    else
        {
        write-host "is registered in SCCM" $client.Computername -ForegroundColor Green
        Add-CMDeviceCollectionDirectMembershipRule  -CollectionName $collection -ResourceId $(get-cmdevice -Name $client.computername).ResourceID -Verbose
        } 
    }