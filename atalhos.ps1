Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

$LNKFILE = "$env:HOMEPATH\desktop\PS-WinApp.lnk"
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$LNKFILE")
$Shortcut.TargetPath = "$env:localappdata\Microsoft\WindowsApps\pwsh.exe"
$Shortcut.Arguments = "-Nop -Executionpolicy bypass"
$Shortcut.IconLocation = "$env:localappdata\Microsoft\WindowsApps\pwsh.exe,0"
$Shortcut.WorkingDirectory = "."
$Shortcut.Save()