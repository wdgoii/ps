Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# invoke-webrequest -uri https://bit.ly/3TkFLPh -outfile .\inicio.ps1

# URL do diretório onde os arquivos estão listado
$directoryUrl = "https://wdgoii.github.io/ps/"

# Obter o conteúdo do diretório
$response = Invoke-WebRequest -Uri $directoryUrl

# Extrair os links dos arquivos
$links = $response.Links | Where-Object { $_.href -match "\.ps1$|\.txt$" }

# Baixar cada arquivo
foreach ($link in $links) {
    $fileName = [System.IO.Path]::GetFileName($link.href)
    $fileUrl = $directoryUrl + $fileName
    Invoke-WebRequest -Uri $fileUrl -OutFile ".\$fileName"
}