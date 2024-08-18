Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
$IPType = "IPv4"
$adapter = Get-NetAdapter | Where-Object {$_.Status -eq "up" -and $_.virtual -eq $false}
$interface = $adapter | Get-NetIPInterface -AddressFamily $IPType

If ($interface.Dhcp -eq "Disabled") {
 # Remove existing gateway
 If (($interface | Get-NetIPConfiguration).Ipv4DefaultGateway) {
 $interface | Remove-NetRoute -Confirm:$false
 }
 # Enable DHCP
 $interface | Set-NetIPInterface -DHCP Enabled
 # Configure the DNS Servers automatically
 $interface | Set-DnsClientServerAddress -ResetServerAddresses

 Clear-DnsClientCache
}


