$SQLServer = "10.156.14.23,1433" #Server
$DataBase = "uoldiveo-dw" #Database
$table="fato_symantec" #Table
$Username = "symantec" #User
$Password = "q1w2e3r4" #Password
$Query = "SELECT * FROM fato_symantec;"
$data = Invoke-SQLCMD -ServerInstance $SQLServer -Database $DataBase -Query $Query -Username $Username -Password $Password -Verbose
#$i=0
$data 
#| foreach-object {$i++}
#$i