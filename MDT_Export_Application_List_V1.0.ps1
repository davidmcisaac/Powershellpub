<#PSScriptInfo
.DESCRIPTION 
Export list of Applications from Microsoft MDT
.VERSION 1.0

.AUTHOR David McIsaac

.COMPANYNAME 

.COPYRIGHT 2017

.EXTERNALSCRIPTDEPENDENCIES 
Requires MDT powershell module
.RELEASENOTES
 Tested on MDT 8443
#>
Import-Module "c:\Program Files\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1" #change if MDT not install on C drive
New-PSDrive -Name "MDT" -PSProvider MDTProvider -Root "i:\MDTBuild"

$apps =Get-ChildItem "MDT:\Applications"-Recurse
$appreport=@()
$appreport= $apps|where-object {$_.NodeType -eq "Application"}|Select-Object Name,shortname,Version,Publisher,enable,language,commandline
$appreport|export-csv c:\MDT_Applications_list_V1.0.csv