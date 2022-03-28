$SQLServer = "192.168.2.1,1433" #Server
$DataBase = "banco" #Database
$table="tabela_symantec" #Table
$Username = "usuario" #User
$Password = "xxxxxx" #Password
$Query = "SELECT * FROM tabela_symantec;"
$data = Invoke-SQLCMD -ServerInstance $SQLServer -Database $DataBase -Query $Query -Username $Username -Password $Password -Verbose
#$i=0
$data 
#| foreach-object {$i++}
#$i
