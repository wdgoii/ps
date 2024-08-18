Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
#mudei aqui
$IPType = "IPv4"
$adapter = Get-NetAdapter | Where-Object {$_.Status -eq "up" -and $_.virtual -eq $false}
$interface = $adapter | Get-NetIPInterface -AddressFamily $IPType

$DHCP = $interface.Dhcp
$IP =       (Get-NetIPConfiguration     -InterfaceIndex $interface.InterfaceIndex).IPv4Address.IPAddress
$MaskBits = (Get-NetIPConfiguration     -InterfaceIndex $interface.InterfaceIndex).IPv4Address.prefixlength
$Gateway =  (Get-NetRoute               -InterfaceIndex $interface.InterfaceIndex -DestinationPrefix '0.0.0.0/0').NextHop
$DNS =      (Get-DnsClientServerAddress -InterfaceIndex $interface.InterfaceIndex -AddressFamily $IPType).ServerAddresses
$info = get-computerinfo|select csmodel, csname, osversion, csmanufacturer, CsProcessors, WindowsBuildLabEx, WindowsProductName, BiosReleaseDate , OsTotalVisibleMemorySize

Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force 1> $null
if ((get-module -name PSWindowsUpdate).Name -ne "PSWindowsUpdate") {
    Install-Module -Name PSWindowsUpdate -Force
}
Import-Module PSWindowsUpdate

Get-ChildItem -Path 'C:\Users\informacoes.txt' | Remove-Item -Force -ErrorAction SilentlyContinue 2> $null
New-Item -Path 'C:\users\informacoes.txt' -ItemType File  1> $null

$IP+"/"+$MaskBits+" gat: "+$Gateway+" dns: "+$DNS+" DHCP: "+$DHCP > C:\Users\informacoes.txt
$info.CsName+" "+$info.CsManufacturer+" "+$info.CsModel >> C:\Users\informacoes.txt
$info.CsProcessors.name >> C:\Users\informacoes.txt
(Get-CimInstance Win32_OperatingSystem).Caption+" => "+$info.WindowsProductName+" "+$info.WindowsBuildLabEx >> C:\Users\informacoes.txt
"bios date: "+$info.BiosReleaseDate >> C:\Users\informacoes.txt
"OsTotalVisibleMemorySize: "+$info.OsTotalVisibleMemorySize >> C:\Users\informacoes.txt
"wuserver : " + ((Get-WUSettings | select wuserver).wuserver) >> C:\Users\informacoes.txt

get-localUser | select name, lastlogon | Sort-Object lastlogon -Descending >> C:\Users\informacoes.txt

get-printer | Where-Object {$_.PortName -match '10.112.'} | select name, portname | format-table -AutoSize >> C:\users\informacoes.txt


"----------------- Atualizacoes 90 dias -----------------" >> C:\Users\informacoes.txt


Get-WUHistory -MaxDate (Get-Date).AddDays(-90) >> C:\Users\informacoes.txt
"---------------------------------------------------------" >> C:\Users\informacoes.txt

