<#PSScriptInfo
.DESCRIPTION 
 Set customer branding within Control Panel\System
.VERSION 1.0

.AUTHOR David McIsaac

.COMPANYNAME 

.COPYRIGHT 2017

.EXTERNALSCRIPTDEPENDENCIES 
Requires MDT powershell module to be loaded during task sequence
.RELEASENOTES
 Tested on MDT 8443 on Windows 7
#>
Import-Module .\ZTIUtility.psm1
Copy-Item "Z:\Applications\Support_logo\user.bmp" "C:\\ProgramData\\Microsoft\\User Account Pictures\\" -Force
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion"
$newkey ="OEMInformation"
$registrypathset = ($registryPath + "\"+$newkey)
$newregitems = @("Logo","C:\\ProgramData\\Microsoft\\User Account Pictures\\user.bmp","string"),
("Manufacturer","CompanyName","string"),
("Model","$TSENV:TaskSequenceName","string"),
("SupportPhone","+44 123","string"),
("SupportUrl","http:\\internalhelpdesk","string")
foreach ($regvalue in $newregitems)
    {
        write-host "Processing" $regvalue[0]
        New-ItemProperty -Path $registrypathset -Name $regvalue[0] -Value $regvalue[1] -PropertyType $regvalue[2]
    }