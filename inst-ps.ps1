Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

Invoke-WebRequest -uri "https://github.com/PowerShell/PowerShell/releases/download/v7.4.4/PowerShell-7.4.4-win-x64.msi" -OutFile .\ps-7.4.4.msi
msiexec.exe /package .\ps-7.4.4.msi /quiet ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1 ADD_FILE_CONTEXT_MENU_RUNPOWERSHELL=1 ENABLE_PSREMOTING=1 REGISTER_MANIFEST=1 USE_MU=1 ENABLE_MU=1 ADD_PATH=1
