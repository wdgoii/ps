Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

#Install-Module -Name PSWindowsUpdate

$IPType = "IPv4"
$adapter = Get-NetAdapter | Where-Object {$_.Status -eq "up" -and $_.virtual -eq $false}
$interface = $adapter | Get-NetIPInterface -AddressFamily $IPType

$DHCP = $interface.Dhcp
$IP =       (Get-NetIPConfiguration     -InterfaceIndex $interface.InterfaceIndex).IPv4Address.IPAddress
$MaskBits = (Get-NetIPConfiguration     -InterfaceIndex $interface.InterfaceIndex).IPv4Address.prefixlength
$Gateway =  (Get-NetRoute               -InterfaceIndex $interface.InterfaceIndex -DestinationPrefix '0.0.0.0/0').NextHop
$DNS =      (Get-DnsClientServerAddress -InterfaceIndex $interface.InterfaceIndex -AddressFamily $IPType).ServerAddresses
$info = get-computerinfo|Select-Object csmodel, csname, osversion, csmanufacturer, CsProcessors, WindowsBuildLabEx, WindowsProductName, BiosReleaseDate , OsTotalVisibleMemorySize



Get-ChildItem -Path 'C:\Users\informacoes.txt' | Remove-Item -Force -ErrorAction SilentlyContinue 2>$null
New-Item -Path 'C:\users\informacoes.txt' -ItemType File  1>$null

$IP+"/"+$MaskBits+" gat: "+$Gateway+" dns: "+$DNS+" DHCP: "+$DHCP > C:\Users\informacoes.txt
$info.CsName+" "+$info.CsManufacturer+" "+$info.CsModel >> C:\Users\informacoes.txt
$info.CsProcessors.name >> C:\Users\informacoes.txt
(Get-CimInstance Win32_OperatingSystem).Caption+" => "+$info.WindowsProductName+" "+$info.WindowsBuildLabEx >> C:\Users\informacoes.txt
"bios date: "+$info.BiosReleaseDate >> C:\Users\informacoes.txt
"OsTotalVisibleMemorySize: "+$info.OsTotalVisibleMemorySize >> C:\Users\informacoes.txt
"wuserver : " + ((Get-WUSettings | Select-Object wuserver).wuserver) >> C:\Users\informacoes.txt

get-localUser | Select-Object name, lastlogon | Sort-Object lastlogon -Descending >> C:\Users\informacoes.txt

get-printer | Where-Object {$_.PortName -match '10.112.'} | select name, portname | format-table -AutoSize >> C:\users\informacoes.txt
"-------------------------------------------------" >> C:\Users\informacoes.txt
Get-PhysicalDisk | Format-Table -AutoSize >> C:\Users\informacoes.txt

#mostrar espaco usado, livre dos hds
Get-PSDrive -PSProvider FileSystem | Select-Object Name, @{Name="Used (GB)"; Expression={[math]::round(($_.Used/1GB),2)}},`
@{Name="Free (GB)"; Expression={[math]::round(($_.Free/1GB),2)}}, @{Name="Total (GB)";`
Expression={[math]::round(($_.Used + $_.Free)/1GB,2)}}  >> C:\Users\informacoes.txt

"----------------- Atualizacoes 90 dias -----------------" >> C:\Users\informacoes.txt
Get-WUHistory -MaxDate (Get-Date).AddDays(-90) >> C:\Users\informacoes.txt
"---------------------------------------------------------" >> C:\Users\informacoes.txt

"----------------- top - cpu - process -----------------" >> C:\Users\informacoes.txt
get-process | Sort-Object -Property CPU -Descending | Select-Object id, cpu, name, path -First 20 | Format-Table  -AutoSize >> C:\Users\informacoes.txt
"---------------------------------------------------------" >> C:\Users\informacoes.txt
"--------------------------programas instalados-----------" >> C:\Users\informacoes.txt
Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion | Where-Object {$_.DisplayName -ne $null} | Sort-Object DisplayName | Format-Table -AutoSize >> C:\Users\informacoes.txt
Get-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion | Where-Object {$_.DisplayName -ne $null} | Sort-Object DisplayName | Format-Table -AutoSize >> C:\Users\informacoes.txt

"--------------------------zenworks-----------" >> C:\Users\informacoes.txt

winget list | Where-Object { $_ -notmatch "Microsoft" } >> C:\Users\informacoes.txt