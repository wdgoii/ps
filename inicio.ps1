Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

Invoke-WebRequest -uri "https://wdgoii.github.io/ps/add-cert.ps1" -OutFile .\add-cert.ps1
Invoke-WebRequest -uri "https://wdgoii.github.io/ps/atalhos.ps1" -OutFile .\atalhos.ps1
Invoke-WebRequest -uri "https://wdgoii.github.io/ps/certificate-install.ps1" -OutFile .\certificate-install.ps1
Invoke-WebRequest -uri "https://wdgoii.github.io/ps/drivers-naoutilizados.ps1" -OutFile .\drivers-naoutilizados.ps1
Invoke-WebRequest -uri "https://wdgoii.github.io/ps/erros-dispositivos.ps1" -OutFile .\erros-dispositivos.ps1
Invoke-WebRequest -uri "https://wdgoii.github.io/ps/fixdhcp.ps1" -OutFile .\fixdhcp.ps1
Invoke-WebRequest -uri "https://wdgoii.github.io/ps/fixip.ps1" -OutFile .\fixip.ps1
Invoke-WebRequest -uri "https://wdgoii.github.io/ps/informacoes.ps1" -OutFile .\informacoes.ps1
Invoke-WebRequest -uri "https://wdgoii.github.io/ps/install-winget.ps1" -OutFile .\install-winget.ps1
Invoke-WebRequest -uri "https://wdgoii.github.io/ps/install.ps1" -OutFile .\install.ps1
Invoke-WebRequest -uri "https://wdgoii.github.io/ps/install.txt" -OutFile .\install.txt
Invoke-WebRequest -uri "https://wdgoii.github.io/ps/lentidao.ps1" -OutFile .\lentidao.ps1
Invoke-WebRequest -uri "https://wdgoii.github.io/ps/printer-add.ps1" -OutFile .\printer-add.ps1
Invoke-WebRequest -uri "https://wdgoii.github.io/ps/reset-windowsupdate.ps1" -OutFile .\reset-windowsupdate.ps1
Invoke-WebRequest -uri "https://wdgoii.github.io/ps/uninstall.ps1" -OutFile .\uninstall.ps1
Invoke-WebRequest -uri "https://wdgoii.github.io/ps/uninstall.txt" -OutFile .\uninstall.txt