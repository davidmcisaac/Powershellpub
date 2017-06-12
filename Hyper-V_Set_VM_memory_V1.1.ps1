<#PSScriptInfo
.DESCRIPTION 
 Hyper-V change a singel virtual machine assigned memory 
 VM is shutdown, memory changed then VM restarted.
.VERSION 1.0

.AUTHOR David McIsaac

.COMPANYNAME 

.COPYRIGHT 2017

.EXTERNALSCRIPTDEPENDENCIES 
Requires Hyper-V Powershell module to be avaliable. 
.RELEASENOTES
 Test on Hyper-V 2012 standalone
#>
Start-Transcript -Path c:\HVVM_changelog.txt -Append #Start script logging
$virtualserver = "virtualservername"
#stop vm
Stop-VM $virtualserver -Verbose
#getvm config before change
Get-VM $virtualserver|Format-List Name,@{label="Memory";expression={$_.MemoryStartup /1024 /1024}} -Verbose
#sleep whislt shutting down
Start-Sleep 301 -Verbose
#set vm memory
get-vm $virtualserver|Set-VMMemory -StartupBytes 8GB -Verbose #change memory to 8GB
Start-Sleep 30 -Verbose
#start vm
start-vm $virtualserver -Verbose
#getvm config after change
Get-VM $virtualserver|Format-List Name,@{label="Memory";expression={$_.MemoryStartup /1024 /1024}} -Verbose
Stop-Transcript #stop script logging