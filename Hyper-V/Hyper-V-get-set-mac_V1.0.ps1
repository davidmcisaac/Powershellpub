<#PSScriptInfo
.DESCRIPTION 
 Two sub functions
 Set mac address for a VM, VM will be rebooted during this process
 List mac addresses of all virtual machines in a cluster
.VERSION 1.0

.AUTHOR David McIsaac

.COMPANYNAME 

.COPYRIGHT 2017

.EXTERNALSCRIPTDEPENDENCIES 

.RELEASENOTES
 Tested on Windows Server 2012 R2 - Hyper-V Cluster
#>
function set-vmmacaddress
{
$vm = "virtualservername" #Set virtual machine name
$vm_nic_info = Get-VMNetworkAdapter -VMName $vm|Select-Object MacAddress
Stop-VM -Name $vm -Verbose
Set-VMNetworkAdapter -VMName $vminfo.name -StaticMacAddress $vm_nic_info.MACaddress -Verbose
Start-VM -Name $vm -Verbose
}

function get-vmMacAddress
{
$VMhost_MACrange=@()
$VMnics=@()
$hvhosts = Get-ClusterNode |Select-Object Name
foreach ($node in $hvhosts)
{
    $VMhost_MACrange += Get-VMHost -ComputerName $node.name|Select-Object Name,MacAddressMaximum,MacAddressMinimum
    $VMnics += Get-VMNetworkAdapter -ComputerName $node.name -All|Select-Object VMname,MACaddress
}
$VMhost_MACrange|Format-Table
$vmics|Format-Table
}