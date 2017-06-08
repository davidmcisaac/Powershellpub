<#PSScriptInfo
.DESCRIPTION 
Export list of applications in SCCM 
.VERSION 1.0

.AUTHOR David McIsaac

.COMPANYNAME 

.COPYRIGHT 2017

.EXTERNALSCRIPTDEPENDENCIES 
Requires SCCM powershell module
.RELEASENOTES
 
#>
Import-Module "c:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1" # change path
$pssccm = @();$sccm_site = @();$apprep=@()
$sccm_site = Get-PSDrive|Where-Object {$_.Provider -match 'CMSite'}|Select-Object Name,sitecode
$pssccm = ($sccm_site.Name + ":")
Set-Location $pssccm 
$scapps =Get-CMApplication
foreach ($app in $scapps)
    {
      $xmlvar= [xml]$app.SDMPackageXML
      $applocation = $xmlvar.AppMgmtDigest.DeploymentType.Installer.Contents.Content.Location
      $type = $xmlvar.AppMgmtDigest.DeploymentType.Technology
      $apprep += $app|Select-Object @{name="Application";exp={$_.LocalizedDisplayName}},Manufacturer,SoftwareVersion,PackageID,@{name="location";exp={$applocation}},@{name="Type";exp={$type}},CreatedBy,DateCreated,LastModifiedBy,DateLastModified
   } 
 $apprep|Export-Csv C:\SCCM_Applications_V1.0.csv -NoTypeInformation