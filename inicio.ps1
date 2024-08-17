# Invoke-WebRequest -uri "https://encurtador.com.br/ci4Pr" -OutFile c:\users\inicio.ps1
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
# criar drive local 
New-Item -Path 'C:\windows\temp\www-yyy-xxx-aaa-apagar' -ItemType Directory
$parameters = @{
    Name = "Docs"
    PSProvider = "FileSystem"
    Root = "C:\windows\temp\www-yyy-xxx-aaa-apagar"
    Description = "Local"
}
New-PSDrive @parameters

# copiar pasta drive mpf => drive local
# descompactar