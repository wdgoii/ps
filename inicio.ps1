# Invoke-WebRequest -uri "https://encurtador.com.br/ci4Pr" -OutFile c:\users\inicio.ps1
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
# criar drive local 
remove-item -Path C:\Windows\Temp\240817 -Recurse -ErrorAction Continue
new-item -Path C:\Windows\Temp\240817 -Type Directory
Remove-PSDrive -Name T1 -ErrorAction Continue
New-PSDrive -Name "T1" -PSProvider FileSystem -Root "C:\Windows\Temp\240817\"


# copiar pasta drive mpf => drive local
# descompactar