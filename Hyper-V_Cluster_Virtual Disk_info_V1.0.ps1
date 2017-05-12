$hvcluster = Get-Cluster #obtain cluster name
$hvclusterhosts = Get-ClusterNode -Cluster $hvcluster.Name #hv hosts for cluster
$hvclustervmroles = Get-ClusterGroup -Cluster $hvcluster.Name|Where-Object {$_.grouptype -eq "VirtualMachine"}#get cluster roles which are Virtual Machines
$vmdetail =@();$vmdetailhdd =@()#Create empty arrays
foreach ($vmrole in $hvclustervmroles)
    {#Loop through each vm and obtain info
        $currentvm = Get-VM -ComputerName $vmrole.OwnerNode -Name $vmrole.name
        $curshareddisk = Get-VMHardDiskDrive -ComputerName $vmrole.OwnerNode -VMName $vmrole.name
        if ($curshareddisk.SupportPersistentReservations -eq $true)
            {#Virtual HDD is shared
            $vhdshared = $True
            }
        else
            {#Virtual HDD not shared
            $vhdshared = $False
            }
        $currentvmhdd = $currentvm.vmid|Get-VHD -ComputerName $vmrole.OwnerNode
        foreach ($vdisk in $currentvmhdd)
            {
            $vdiskdetail =$vdisk|Select-Object @{Name="VM Name";exp={$vmrole.Name}},@{Name="Shared VHDs";exp={$vhdshared}},@{Name="VHD Type";exp={$_.vhdtype}},@{Name="VHD Path";exp={$_.path}},@{Name="VHD Format";exp={$_.vhdformat}},@{name="Current size GB";exp={[math]::round(($_.filesize /1GB),2)}},@{name="Max size GB";exp={[math]::round(($_.size /1GB),2)}}
            $vmdetailhdd +=$vdiskdetail
            }       
    }
$vmdetailhdd|export-csv C:\consilium\VM_hdd_info.csv -NoTypeInformation
