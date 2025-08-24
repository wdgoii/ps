Clear-Host

Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue

Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache\*" -Recurse -Force -ErrorAction SilentlyContinue
Get-ChildItem "$env:APPDATA\Mozilla\Firefox\Profiles\" -Directory | ForEach-Object {
    $cachePath = "$($_.FullName)\cache2\*"
    Remove-Item -Path $cachePath -Recurse -Force -ErrorAction SilentlyContinue
}

Start-Process "cleanmgr.exe" -ArgumentList "/sagerun:1"