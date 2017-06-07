<#PSScriptInfo
.DESCRIPTION 
 Currently lists all enabled AD accounts and shows PasswordLastSet
 User prompt provided to enter maximum password age
.VERSION 1.0

.AUTHOR David McIsaac

.COMPANYNAME 

.COPYRIGHT 2017

.EXTERNALSCRIPTDEPENDENCIES 
 Requires AD module to be avaliable. 
.RELEASENOTES
 
#>
$seviceaccountprefix = "sv","sccm","sccm","scsm","sql"
$TodaysDate = Get-Date #Get todays date
$passwordage = read-host  "Enter Maximum password age i.e. 90, 180 days"
$TargetDateRange = $TodaysDate.AddDays(-$passwordage)
$newadaccount =@()#Declare empty array
$adaccount = Get-ADUser -Filter * -Properties samaccountname,LastLogonDate,PasswordLastSet, whencreated |Where-Object {$_.enabled -eq $true -and $_.PasswordLastSet -lt $TargetDateRange} |Sort-Object -Property LastLogonDate -Descending |Select-Object Name, samaccountname, LastLogonDate, PasswordLastSet, Enabled, WhenCreated
foreach ($u in $adaccount)
    {#loop through each AD user account
    $user_is_serviceaccount = 0 #Reset service account counter
    foreach ($sv in $seviceaccountprefix)
            {
            if ($u.samaccountname -like ($sv+"*"))#Check if samaccountname is like any of the service accounts defined above
                {
                write-host "service account detected" $u.samaccountname $sv
                $user_is_serviceaccount ++
                }
            }
    if ($user_is_serviceaccount -eq 0)
        {#user account isnt a service account add to filtered export list
        $newadaccount += $u
        }
    }
$adaccount | export-csv ("C:\UserLastLogonDateV1.0.csv") -NoTypeInformation #Lists all AD accounts
$newadaccount | export-csv ("C:\UserLastLogonDate_FilteredV1.1.csv") -NoTypeInformation #Lists AD accounts as per input critera