<#PSScriptInfo
.DESCRIPTION 
Create sample CSV file to be used with script \Powershellpub\SCCM_Create_collection_from_csv_V1.0.ps1
.VERSION 1.0

.AUTHOR David McIsaac

.COMPANYNAME 

.COPYRIGHT 2017

.EXTERNALSCRIPTDEPENDENCIES 

.RELEASENOTES
 
#>
$computerlist =("PC-WIN7-01"),
("PC-WIN7-02"),
("PC-WIN7-03"),
("PC-WIN7-04"),
("PC-WIN7-05"),
("PC-WIN7-06"),
("PC-WIN7-07"),
("PC-WIN7-08"),
("PC-WIN7-09"),
("PC-WIN7-10")
$columnname = "ComputerName";$computerlist_export=@()
Foreach ($entry in $computerlist)
    {   
        $row = New-Object -TypeName psobject
        $row |add-member -membertype NoteProperty -name $columnname -value $entry
        $computerlist_export += $row
    }
$computerlist_export|Export-Csv C:\SCCM_computer_list_import_V1.0.csv -NoTypeInformation