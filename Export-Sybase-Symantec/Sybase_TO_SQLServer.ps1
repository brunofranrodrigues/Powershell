#Config SQLServer
$sqlServer = "10.156.14.23"
$sqlDB = "uoldiveo-dw"
$sqlTable = "fato_symantec"
$uid = "symantec"
$pwd = "q1w2e3r4"

$Logfile = "D:\Task-Export\proc_$env:computername.log"
function WriteLog
{
Param ([string]$LogString)
$Stamp = (Get-Date).toString("yyyy/MM/dd HH:mm:ss")
$LogMessage = "$Stamp $LogString"
Add-content $LogFile -value $LogMessage
}

WriteLog "Create export from Sybase Symantec Endpoint Protection Manager to CSV”
#Create export from Sybase Symantec Endpoint Protection Manager to CSV
& "C:\Program Files (x86)\Symantec\Symantec Endpoint Protection Manager\ASA\win32\dbisqlc.exe" -ODBC -c "DSN=SymantecEndpointSecurityDSN;UID=dba;PWD=Hymtecse#4096" D:\Task-Export\SQLExport.sql

Start-Sleep -s 4
WriteLog "Making changes to the file D:\Task-Export\hosts_status.csv"
#Remove caracter "'"
$file = "D:\Task-Export\hosts_status.csv"
Get-Content $file | Foreach {$_ -replace "\'", ""}  | Set-Content "D:\Task-Export\hosts_status02.csv"

Start-Sleep -s 4
$file02 = "D:\Task-Export\hosts_status02.csv"
#Remove caracter " rev. XXX"
WriteLog "Remove the pattern rev. XXX"
Get-Content $file02  | Foreach {$_ -replace "[ ][a-z]{3}[. ]+[0-9]{3}", ""}  | Set-Content "D:\Task-Export\hosts_status03.csv"

#Import CSV custom file from Sybase
$csv="D:\Task-Export\hosts_status03.csv"

Start-Sleep -s 4
WriteLog "Clear the table for the import - DELETE FROM fato_symantec"
$Query = "DELETE FROM [$sqlTable]"
$data = Invoke-SQLCMD -ServerInstance $sqlServer -Database $sqlDB -Query $Query -Username $uid -Password $pwd

Start-Sleep -s 4
#Import CSV custom file from Sybase
$data = Import-CSV $csv -header HOST , SYMANTEC_STATUS , DATE, VERSION, OS -Encoding utf8 -Delimiter "," | Foreach-Object{
$Query="INSERT INTO $sqlTable VALUES ('$($_.HOST)','$($_.SYMANTEC_STATUS)','$($_.DATE)','$($_.VERSION)','$($_.OS)')"
Invoke-SQLCMD -ServerInstance $sqlServer -Database $sqlDB -Query $Query -Username $uid -Password $pwd
}

WriteLog "Import CSV custom file from Sybase - hosts_status03.csv"
Remove-Item -Path D:\Task-Export\hosts_status.csv
Remove-Item -Path D:\Task-Export\hosts_status02.csv
Remove-Item -Path D:\Task-Export\hosts_status03.csv
WriteLog "Delete file D:\Task-Export\hosts_status.csv"
WriteLog "Delete file D:\Task-Export\hosts_status02.csv"
WriteLog "Delete file D:\Task-Export\hosts_status03.csv"