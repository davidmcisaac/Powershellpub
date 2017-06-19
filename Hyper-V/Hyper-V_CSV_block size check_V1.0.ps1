$wql = "SELECT Label, Blocksize, Name FROM Win32_Volume WHERE FileSystem='NTFS'"
Get-WmiObject -Query $wql -ComputerName '.' | Select-Object Label, Blocksize, Name


#{get-volume |select filesystemlabel,filesystemtype,allocationunitsize}