<#PSScriptInfo
.DESCRIPTION 
 Clear Exchange IIS logs older than 30 days, change retain logs variable to desire days to retain logs.
 updated:with comments and amendments

.VERSION 1.0

.AUTHOR David McIsaac

.COMPANYNAME 

.COPYRIGHT 2017

.EXTERNALSCRIPTDEPENDENCIES 
 Requires Exchange Powershell Module
.RELEASENOTES
 Tested on Exchange 2013
#>
$Retain_Logs = 30 #value is number of days
$Logpath = "C:\Logs\" #directory to save logs
$TodaysDate = Get-Date
$ExchangeWWW = Get-Website -Name "Exchange Back End" #Get Exchange WWW
$ExchangeIISLog = $ExchangeWWW.logFile.directory #Find IIS Log location
$LogFilesDeleted = ($Logpath + "\IISlogsDeleted_$(get-date -f dd-MM-yy).txt")
$DeleteOlderThan = $TodaysDate.AddDays(-$Retain_Logs)
Write-host "Starting script $TodaysDate"
if ($ExchangeIISLog -cge "%SystemDrive%")
        {#Check if IIS logs is on %Systemdrive%, if so replace variable with static path
            $newpath = $ExchangeIISLog -replace "%SystemDrive%","C:"
            add-content $LogFilesDeleted "IIS Log folder for Exchange located here $newpath"
            #Obtain IIS logs to be delete as per critera
            $LogsToDelete = Get-ChildItem $newpath -Include *.log -Recurse | Where-object {$_.LastWriteTime -le "$DeleteOlderThan"}
            add-content $LogFilesDeleted "Number of IIS logs which meet critera (($LogsToDelete).count)"
            add-content $LogFilesDeleted "------------------------------------------------------------------------"
        }
else
        {#IIS logs is not on %Systemdrive%, use retrieved path
            add-content $LogFilesDeleted "IIS Log folder for Exchange located here $ExchangeIISLog"
            #Obtain IIS logs to be delete as per critera
            $LogsToDelete = Get-ChildItem $ExchangeIISLog -Include *.log -Recurse | Where-object {$_.LastWriteTime -le "$DeleteOlderThan"}
            add-content $LogFilesDeleted "Number of IIS logs which meet critera (($LogsToDelete).count)"
            add-content $LogFilesDeleted "------------------------------------------------------------------------"
        } 
Write-host "Starting to clear Logs"
$successcounter = 0
$failedcounter = 0
foreach ($File in $LogsToDelete)
    {#Loop through each file older than value set in $Retain_Logs and record success
        Remove-Item $File -ea SilentlyContinue
        $filestatus = Test-path $File    
        if ($filestatus -eq $True)
        {#If file still exists after remove-item executed and test-path -eq $true
            add-content $LogFilesDeleted "Failed to delete $file"
            $failedcounter ++
        }
        elseif ($filestatus -eq $False)
        {#If file is deleted after remove-item executed and test-path -eq $false   
            add-content $LogFilesDeleted "Successfully deleted $file"
            $successcounter ++
        }
    }
add-content $LogFilesDeleted "------------------------------------------------------------------------"
add-content $LogFilesDeleted "Finished deleting IIS Logs files located in $IISLogsPath on $TodaysDate" 
add-content $LogFilesDeleted "Number of log files deleted $successcounter" 
add-content $LogFilesDeleted "Number of log fies which failed to delete $failedcounter"
add-content $LogFilesDeleted "------------------------------------------------------------------------"
Write-host "Check $LogFilesDeleted for list of files deleted successfully and any errors"  