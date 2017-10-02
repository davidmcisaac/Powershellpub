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
$sourcepath = "C:\source" # place C++ installers in here
Import-Module "e:\Program Files\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1" #change if MDT not install on C drive
New-PSDrive -Name "MDT" -PSProvider MDTProvider -Root "e:\mdt" # Enter deployment share root
New-Item "MDT:\Applications\Microsoft" -ItemType directory -ErrorAction SilentlyContinue #Create Microsoft Directory within Applications

#2008
$ApplicationName = "Install - Microsoft Visual C++ 2008 SP1 - x86"
$CommandLine = "vcredist_x86.exe /Q"
$ApplicationSourcePath = $sourcepath + "\c++\2008"
Import-MDTApplication -Path "MDT:\Applications\Microsoft" -Enable "True" -Name $ApplicationName -ShortName $ApplicationName -Commandline $Commandline -WorkingDirectory ".\Applications\$ApplicationName" -ApplicationSourcePath $ApplicationSourcePath -DestinationFolder $ApplicationName -Verbose
#2008
$ApplicationName = "Install - Microsoft Visual C++ 2008 SP1 - x64"
$CommandLine = "vcredist_x64.exe /Q"
$ApplicationSourcePath = $sourcepath + "\c++\2008"
Import-MDTApplication -Path "MDT:\Applications\Microsoft" -Enable "True" -Name $ApplicationName -ShortName $ApplicationName -Commandline $Commandline -WorkingDirectory ".\Applications\$ApplicationName" -ApplicationSourcePath $ApplicationSourcePath -DestinationFolder $ApplicationName -Verbose
#2010
$ApplicationName = "Install - Microsoft Visual C++ 2010 SP1 - x86"
$CommandLine = "en_visual_c_pp_2010_sp1_redistributable_package_x86_651767.exe /Q"
$ApplicationSourcePath = $sourcepath + "\c++\2010"
Import-MDTApplication -Path "MDT:\Applications\Microsoft" -Enable "True" -Name $ApplicationName -ShortName $ApplicationName -CommandLine $CommandLine -WorkingDirectory ".\Applications\$ApplicationName" -ApplicationSourcePath $ApplicationSourcePath -DestinationFolder $ApplicationName -Verbose
#2010
$ApplicationName = "Install - Microsoft Visual C++ 2010 SP1 - x64"
$CommandLine = "en_visual_c_pp_2010_sp1_redistributable_package_x64_651767.exe /Q"
$ApplicationSourcePath = $sourcepath + "\c++\2010"
Import-MDTApplication -Path "MDT:\Applications\Microsoft" -Enable "True" -Name $ApplicationName -ShortName $ApplicationName -CommandLine $CommandLine -WorkingDirectory ".\Applications\$ApplicationName" -ApplicationSourcePath $ApplicationSourcePath -DestinationFolder $ApplicationName -Verbose
#2012
$ApplicationName = "Install - Microsoft Visual C++ 2012 update4 - x64"
$CommandLine = "en_visual_cpp_redistributable_for_visual_studio_2012_update_4_x64_3161523.exe /Q"
$ApplicationSourcePath = $sourcepath + "\c++\2012"
Import-MDTApplication -Path "MDT:\Applications\Microsoft" -Enable "True" -Name $ApplicationName -ShortName $ApplicationName -CommandLine $CommandLine -WorkingDirectory ".\Applications\$ApplicationName" -ApplicationSourcePath $ApplicationSourcePath -DestinationFolder $ApplicationName -Verbose
#2012
$ApplicationName = "Install - Microsoft Visual C++ 2012 update4 - x86"
$CommandLine = "en_visual_cpp_redistributable_for_visual_studio_2012_update_4_x86_3161523.exe /Q"
$ApplicationSourcePath = $sourcepath +  "\c++\2012"
Import-MDTApplication -Path "MDT:\Applications\Microsoft" -Enable "True" -Name $ApplicationName -ShortName $ApplicationName -CommandLine $CommandLine -WorkingDirectory ".\Applications\$ApplicationName" -ApplicationSourcePath $ApplicationSourcePath -DestinationFolder $ApplicationName -Verbose
#2013
$ApplicationName = "Install - Microsoft Visual C++ 2013 - x86"
$CommandLine = "en_visual_cpp_redistributable_for_visual_studio_2013_x86_3009077.exe /Q"
$ApplicationSourcePath = $sourcepath + "\c++\2013\"
Import-MDTApplication -Path "MDT:\Applications\Microsoft" -Enable "True" -Name $ApplicationName -ShortName $ApplicationName -CommandLine $CommandLine -WorkingDirectory ".\Applications\$ApplicationName" -ApplicationSourcePath $ApplicationSourcePath -DestinationFolder $ApplicationName -Verbose
#2013
$ApplicationName = "Install - Microsoft Visual C++ 2013 - x64"
$CommandLine = "en_visual_cpp_redistributable_for_visual_studio_2013_x64_3009077.exe /Q"
$ApplicationSourcePath = $sourcepath + "\c++\2013\"
Import-MDTApplication -Path "MDT:\Applications\Microsoft" -Enable "True" -Name $ApplicationName -ShortName $ApplicationName -CommandLine $CommandLine -WorkingDirectory ".\Applications\$ApplicationName" -ApplicationSourcePath $ApplicationSourcePath -DestinationFolder $ApplicationName -Verbose
#2015
$ApplicationName = "Install - Microsoft Visual C++ 2015 Update 3 - x86"
$CommandLine = "mu_visual_cpp_2015_redistributable_update_3_x86_9052536.exe /Q"
$ApplicationSourcePath = $sourcepath + "\c++\2015"
Import-MDTApplication -Path "MDT:\Applications\Microsoft" -Enable "True" -Name $ApplicationName -ShortName $ApplicationName -CommandLine $CommandLine -WorkingDirectory ".\Applications\$ApplicationName" -ApplicationSourcePath $ApplicationSourcePath -DestinationFolder $ApplicationName -Verbose
#2015
$ApplicationName = "Install - Microsoft Visual C++ 2015 Update 3 - x64"
$CommandLine = "mu_visual_cpp_2015_redistributable_update_3_x64_9052538.exe /Q"
$ApplicationSourcePath = $sourcepath + "\c++\2015\"
Import-MDTApplication -Path "MDT:\Applications\Microsoft" -Enable "True" -Name $ApplicationName -ShortName $ApplicationName -CommandLine $CommandLine -WorkingDirectory ".\Applications\$ApplicationName" -ApplicationSourcePath $ApplicationSourcePath -DestinationFolder $ApplicationName -Verbose

#2017
$ApplicationName = "Install - Microsoft Visual C++ 2017 version 15.3 - x64"
$CommandLine = "mu_visual_cpp_redistributable_for_visual_studio_2017_version_15.3_x64_11100230.exe /Q"
$ApplicationSourcePath = $sourcepath + "\c++\2017\"
Import-MDTApplication -Path "MDT:\Applications\Microsoft" -Enable "True" -Name $ApplicationName -ShortName $ApplicationName -CommandLine $CommandLine -WorkingDirectory ".\Applications\$ApplicationName" -ApplicationSourcePath $ApplicationSourcePath -DestinationFolder $ApplicationName -Verbose

#2017
$ApplicationName = "Install - Microsoft Visual C++ 2017 version 15.3 - x86"
$CommandLine = "mu_visual_cpp_redistributable_for_visual_studio_2017_version_15.3_x86_11100230.exe /Q"
$ApplicationSourcePath = $sourcepath + "\c++\2017\"
Import-MDTApplication -Path "MDT:\Applications\Microsoft" -Enable "True" -Name $ApplicationName -ShortName $ApplicationName -CommandLine $CommandLine -WorkingDirectory ".\Applications\$ApplicationName" -ApplicationSourcePath $ApplicationSourcePath -DestinationFolder $ApplicationName -Verbose