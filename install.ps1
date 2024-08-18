Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
foreach($line in Get-Content -Path ".\install.txt")
{
   winget install "$line"
}