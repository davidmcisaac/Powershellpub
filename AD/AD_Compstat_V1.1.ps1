<#PSScriptInfo
.DESCRIPTION 
Report AD computer Account audit
.VERSION 1.1

.AUTHOR David McIsaac

.COMPANYNAME 

.COPYRIGHT 2017

.EXTERNALSCRIPTDEPENDENCIES 
 Tested on Windows Server 2012 and 2012 R2
 Requires AD module to be avaliable. 
.RELEASENOTES
A bit of help from these posts 
 #ref https://technet.microsoft.com/en-us/library/dd378867(v=ws.10).aspx
 #ref https://blogs.technet.microsoft.com/askds/2009/04/15/the-lastlogontimestamp-attribute-what-it-was-designed-for-and-how-it-works/
 .Change Log From V1.0 to V1.1
  Implemented log path variable
 #>
$script:logpath = "C:\ADlogs\"
$createpath = Test-path $logpath
if ($createpath -eq $true)
    {
    write-host "Logs exporting to" $logpath
    }
elseif ($createpath -eq $false)
    {
    new-item -path $logpath -ItemType Directory
    write-host "Created log path and exporting to" $logpath
    }
function Get-ADCompstat
{write-host "Processing..." -ForegroundColor Cyan
    $script:ADcompReport=@();$script:ADaccounts=@()
    $script:ADaccounts = Get-ADComputer -Filter * -Properties Description,lastLogontimestamp,lastlogondate,Created,OperatingSystem, OperatingSystemServicePack ,IPv4Address |Select-Object Name,Enabled,Description,lastLogontimestamp,lastlogondate,Created,OperatingSystem, OperatingSystemServicePack ,IPv4Address;Write-Host "Number of AD Computer Accounts to Process -"$ADaccounts.count -ForegroundColor yellow
    $ADacountsenabled = $ADaccounts|Where-Object {$_.enabled -eq $true};Write-Host "Number of AD Computer Accounts Enabled -" $ADacountsenabled.count -ForegroundColor Green
    $ADacountsdisabled = $ADaccounts|Where-Object {$_.enabled -eq $false};Write-Host "Number of AD Computer Accounts Disabled -" $ADacountsdisabled.count -ForegroundColor Red
    foreach ($comp in $script:ADaccounts)
    {
        $time = 0
        if($comp.lastLogontimestamp -gt $time) 
        {
            $time = $comp.lastLogontimestamp 
        }
    $dt = [DateTime]::FromFileTime($time)
    $script:ADcompReport +=$comp|Select-Object Name,Enabled,Description,@{name="lastLogontimestamp";exp={$dt}},lastlogondate,Created,OperatingSystem, OperatingSystemServicePack ,IPv4Address
    }
    Write-host "Enabled Client Operating Systems Overview" -ForegroundColor Magenta
$clientos0 =$ADaccounts|Where-Object {$_.OperatingSystem -notlike "Windows*" -and $_.enabled -eq $true}
if ($clientos0.count -gt 0 )
    {
    Write-Host "Number of Non-Windows or unknown Computers -" $clientos0.count
    }
$clientos2kpro =$ADaccounts|Where-Object {$_.OperatingSystem -like "Windows 2000 Pro*" -and $_.enabled -eq $true}
if ($clientos2kpro.count -gt 0 )
    {
    Write-Host "Number of Windows 2000 Pro Computers -" $clientos2kpro.count
    }
$clientosXPpro =$ADaccounts|Where-Object {$_.OperatingSystem -like "Windows XP Pro*" -and $_.enabled -eq $true}
if ($clientosXPpro.count -gt 0)
    {
    Write-Host "Number of Windows XP Pro Computers -" $clientosXPpro.count
    }
$clientos10propro =$ADaccounts|Where-Object {$_.OperatingSystem -like "Windows 7 Pro*" -and $_.enabled -eq $true}
if ($clientos10propro.count -gt 0)
    {
    Write-Host "Number of Windows 7 Pro Computers -" $clientos10propro.count
    }
$clientos10proent =$ADaccounts|Where-Object {$_.OperatingSystem -like "Windows 7 Ent*" -and $_.enabled -eq $true}
if ($clientos10proEnt.count -gt 0)
    {
    Write-Host "Number of Windows 7 Ent Computers -" $clientos10proEnt.count
    }
$clientos8pro =$ADaccounts|Where-Object {$_.OperatingSystem -like "Windows 8 Pro*" -and $_.enabled -eq $true}
if ($clientos8pro.count -gt 0)
    {
    Write-Host "Number of Windows 8 Pro Computers -" $clientos8pro.count
    }
$clientos81pro =$ADaccounts|Where-Object {$_.OperatingSystem -like "Windows 8.1 Pro*" -and $_.enabled -eq $true}
if ($clientos81pro.count -gt 0)
    {
    Write-Host "Number of Windows 8.1 Pro Computers -" $clientos81pro.count
    }
$clientos8ent =$ADaccounts|Where-Object {$_.OperatingSystem -like "Windows 8 Ent*" -and $_.enabled -eq $true}
if ($clientos8ent.count -gt 0)
    {
    Write-Host "Number of Windows 8 Enterprise Computers -" $clientos8ent.count
    }
$clientos81ent =$ADaccounts|Where-Object {$_.OperatingSystem -like "Windows 8.1 Ent*" -and $_.enabled -eq $true}
if ($clientos81ent.count -gt 0)
    {
    Write-Host "Number of Windows 8.1 Enterprise Computers -" $clientos81ent.count
    }
$clientos10ent =$ADaccounts|Where-Object {$_.OperatingSystem -like "Windows 10 Enterprise*" -and $_.enabled -eq $true}
if ($clientos10ent.count -gt 0)
    {
    Write-Host "Number of Windows 10 Enterprise Computers -" $clientos10ent.count
    }
$clientos10pro =$ADaccounts|Where-Object {$_.OperatingSystem -like "Windows 10 Pro*" -and $_.enabled -eq $true}
if ($clientos10pro.count -gt 0)
    {
    Write-Host "Number of Windows 10 Pro Computers -" $clientos10pro.count
    } 
    Write-host "Enabled Server Operating Systems Overview" -ForegroundColor Magenta 
$serveros2k =$ADaccounts|Where-Object {$_.OperatingSystem -like "Windows 2000 Server" -and $_.enabled -eq $true}
if ($serveros2k.count -gt 0)
    {
    Write-Host "Number of Windows Server 2000 Standard Computers -" $serveros2k.count
    }
$serveros03std =$ADaccounts|Where-Object {$_.OperatingSystem -like "Windows Server 2003" -and $_.enabled -eq $true}
if ($serveros03std.count -gt 0)
    {
    Write-Host "Number of Windows Server 2003 Standard Computers -" $serveros03std.count
    } 
$serveros03r2std =$ADaccounts|Where-Object {$_.OperatingSystem -like "Windows Server 2003 R2" -and $_.enabled -eq $true}
if ($serveros03r2std.count -gt 0)
    {
    Write-Host "Number of Windows Server 2003 R2 Standard Computers -" $serveros03std.count
    }
$serveros08std =$ADaccounts|Where-Object {$_.OperatingSystem -like "Windows Server? 2008 Standard*" -and $_.enabled -eq $true}
if ($serveros08std.count -gt 0)
    {
    Write-Host "Number of Windows Server 2008 Standard Computers -" $serveros08std.count
    }  
$serveros08r2std =$ADaccounts|Where-Object {$_.OperatingSystem -like "Windows Server 2008 R2 Standard*" -and $_.enabled -eq $true}
if ($serveros08r2std.count -gt 0)
    {
    Write-Host "Number of Windows Server 2008 R2 Standard Computers -" $serveros08r2std.count
    }
$serveros12std =$ADaccounts|Where-Object {$_.OperatingSystem -like "Windows Server 2012 Standard*" -and $_.enabled -eq $true}
if ($serveros12std.count -gt 0)
    {
    Write-Host "Number of Windows Server 2012 Standard Computers -" $serveros12std.count
    } 
$serveros12r2std =$ADaccounts|Where-Object {$_.OperatingSystem -like "Windows Server 2012 R2 Standard*" -and $_.enabled -eq $true}
if ($serveros12r2std.count -gt 0)
    {
    Write-Host "Number of Windows Server 2012 R2 Standard Computers -" $serveros12r2std.count
    }
$serveros12dtc =$ADaccounts|Where-Object {$_.OperatingSystem -like "Windows Server 2012 Datacenter*" -and $_.enabled -eq $true}
if ($serveros12dtc.count -gt 0)
    {
    Write-Host "Number of Windows Server 2012 Datacenter Computers -" $serveros12dtc.count
    } 
$serveros12r2dtc =$ADaccounts|Where-Object {$_.OperatingSystem -like "Windows Server 2012 R2 Datacenter*" -and $_.enabled -eq $true}
if ($serveros12r2dtc.count -gt 0)
    {
    Write-Host "Number of Windows Server 2012 R2 Datacenter Computers -" $serveros12r2dtc.count
    } 
    $script:ADcompReport|Sort-Object Name|Export-Csv -NoTypeInformation ($logpath +"ADComputerStatusReport_V1.1.csv")
    Write-Host "Active Directory computer account status report exported to" ($logpath +"ADComputerStatusReport_V1.1.csv")
    write-host "End of Script..." -ForegroundColor Cyan
 }
 Get-ADCompstat