# Carregar a biblioteca System.Data.SQLite
Add-Type -Path "C:\sqlite\System.Data.SQLite.dll"

# Caminho para o banco de dados SQLite
$dbPath = "C:\sqlite\BD\wdg"

# Conectar ao banco de dados
$connectionString = "Data Source=$dbPath;Version=3;"
$connection = New-Object System.Data.SQLite.SQLiteConnection($connectionString)
$connection.Open()

# computadores(id int, patrimonio varchar(20), so varchar(20));
$commandText = "INSERT INTO computadores (id, patrimonio,so) VALUES (1, 'patrimonio1', 'Windows 10')"
$command = $connection.CreateCommand()
$command.CommandText = $commandText

# Executar o comando
$command.ExecuteNonQuery()

# Fechar a conexão
$connection.Close()