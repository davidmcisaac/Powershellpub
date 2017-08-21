<#PSScriptInfo
 .DESCRIPTION 
Import Queries in SCCM 
.VERSION 1.0

.AUTHOR David McIsaac

.COMPANYNAME 

.COPYRIGHT 2017

.EXTERNALSCRIPTDEPENDENCIES 
Requires SCCM powershell module
.RELEASENOTES
 
#>
Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1" # Import the ConfigurationManager.psd1 module 

$pssccm = @();$sccm_site = @();$scqueryimport=@()
$sccm_site = Get-PSDrive|Where-Object {$_.Provider -match 'CMSite'}|Select-Object Name,sitecode
$pssccm = ($sccm_site.Name + ":")
Set-Location $pssccm 
$scqueryimport = import-csv "c:\SCCM_queries_V1.0.csv" #import exported queries to array
foreach ($qry in $scqueryimport)
  {if ((Get-CMQuery -Name $qry.name) -eq $null) #check if query already exists, ifnot then proceed
    {New-CMQuery -Name $qry.name -Comment $qry.Comments -Expression $qry.Expression -LimitToCollectionId $qry.LimitToCollectionID -TargetClassName $qry.TargetClassName -Verbose
    }
   }