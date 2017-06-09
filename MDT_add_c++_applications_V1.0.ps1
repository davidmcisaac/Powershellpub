<#PSScriptInfo
.DESCRIPTION 
Add visual C++ redistributables to MDT deployment share
.VERSION 1.0

.AUTHOR David McIsaac

.COMPANYNAME 

.COPYRIGHT 2017

.EXTERNALSCRIPTDEPENDENCIES 

.RELEASENOTES
 Bulk of content from Microsoft from the below URL. Customised for my environment.
 https://docs.microsoft.com/en-us/windows/deployment/deploy-windows-mdt/create-a-windows-10-reference-image
#>
Import-Module "c:\Program Files\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1" #change if MDT not install on C drive
New-PSDrive -Name "DS001" -PSProvider MDTProvider -Root "d:\deploymentshare"
New-Item "DS001:\Applications\Microsoft" -ItemType directory -ErrorAction SilentlyContinue #Create Microsoft Directory within Applications

$ApplicationName = "Install - Microsoft Visual C++ 2008 SP1 - x86"
$CommandLine = "vcredist_x86.exe /Q"
$ApplicationSourcePath = "c:\source\c++\2008"
Import-MDTApplication -Path "DS001:\Applications\Microsoft" -Enable "True" -Name $ApplicationName -ShortName $ApplicationName -Commandline $Commandline -WorkingDirectory ".\Applications\$ApplicationName" -ApplicationSourcePath $ApplicationSourcePath -DestinationFolder $ApplicationName -Verbose

$ApplicationName = "Install - Microsoft Visual C++ 2008 SP1 - x64"
$CommandLine = "vcredist_x64.exe /Q"
$ApplicationSourcePath = "c:\source\c++\2008"
Import-MDTApplication -Path "DS001:\Applications\Microsoft" -Enable "True" -Name $ApplicationName -ShortName $ApplicationName -Commandline $Commandline -WorkingDirectory ".\Applications\$ApplicationName" -ApplicationSourcePath $ApplicationSourcePath -DestinationFolder $ApplicationName -Verbose

$ApplicationName = "Install - Microsoft Visual C++ 2010 SP1 - x86"
$CommandLine = "vcredist_x86.exe /Q"
$ApplicationSourcePath = "c:\source\c++\2010"
Import-MDTApplication -Path "DS001:\Applications\Microsoft" -Enable "True" -Name $ApplicationName -ShortName $ApplicationName -CommandLine $CommandLine -WorkingDirectory ".\Applications\$ApplicationName" -ApplicationSourcePath $ApplicationSourcePath -DestinationFolder $ApplicationName -Verbose

$ApplicationName = "Install - Microsoft Visual C++ 2010 SP1 - x64"
$CommandLine = "vcredist_x64.exe /Q"
$ApplicationSourcePath = "c:\source\c++\2010"
Import-MDTApplication -Path "DS001:\Applications\Microsoft" -Enable "True" -Name $ApplicationName -ShortName $ApplicationName -CommandLine $CommandLine -WorkingDirectory ".\Applications\$ApplicationName" -ApplicationSourcePath $ApplicationSourcePath -DestinationFolder $ApplicationName -Verbose

$ApplicationName = "Install - Microsoft Visual C++ 2013 - x86"
$CommandLine = "vcredist_x86.exe /Q"
$ApplicationSourcePath = "c:\source\c++\2013\"
Import-MDTApplication -Path "DS001:\Applications\Microsoft" -Enable "True" -Name $ApplicationName -ShortName $ApplicationName -CommandLine $CommandLine -WorkingDirectory ".\Applications\$ApplicationName" -ApplicationSourcePath $ApplicationSourcePath -DestinationFolder $ApplicationName -Verbose

$ApplicationName = "Install - Microsoft Visual C++ 2013 - x64"
$CommandLine = "vcredist_x64.exe /Q"
$ApplicationSourcePath = "c:\source\c++\2013\"
Import-MDTApplication -Path "DS001:\Applications\Microsoft" -Enable "True" -Name $ApplicationName -ShortName $ApplicationName -CommandLine $CommandLine -WorkingDirectory ".\Applications\$ApplicationName" -ApplicationSourcePath $ApplicationSourcePath -DestinationFolder $ApplicationName -Verbose

$ApplicationName = "Install - Microsoft Visual C++ 2015 Update 3 - x86"
$CommandLine = "mu_visual_cpp_2015_redistributable_update_3_x86_9052536.exe /Q"
$ApplicationSourcePath = "c:\source\c++\2015"
Import-MDTApplication -Path "DS001:\Applications\Microsoft" -Enable "True" -Name $ApplicationName -ShortName $ApplicationName -CommandLine $CommandLine -WorkingDirectory ".\Applications\$ApplicationName" -ApplicationSourcePath $ApplicationSourcePath -DestinationFolder $ApplicationName -Verbose

$ApplicationName = "Install - Microsoft Visual C++ 2015 Update 3 - x64"
$CommandLine = "mu_visual_cpp_2015_redistributable_update_3_x64_9052538.exe /Q"
$ApplicationSourcePath = "c:\source\c++\2015\"
Import-MDTApplication -Path "DS001:\Applications\Microsoft" -Enable "True" -Name $ApplicationName -ShortName $ApplicationName -CommandLine $CommandLine -WorkingDirectory ".\Applications\$ApplicationName" -ApplicationSourcePath $ApplicationSourcePath -DestinationFolder $ApplicationName -Verbose