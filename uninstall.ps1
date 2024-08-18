foreach ($line in Get-Content -Path ".\uninstall.txt") {
    winget uninstall "$line"
}