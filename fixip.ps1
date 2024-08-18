Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

$IPType = "IPv4"
$adapter = Get-NetAdapter | Where-Object {$_.Status -eq "up" -and $_.virtual -eq $false}
$interface = $adapter | Get-NetIPInterface -AddressFamily $IPType

if ($interface.Dhcp -eq 'Enabled') {
    
    $IP =       (Get-NetIPConfiguration     -InterfaceIndex $interface.InterfaceIndex).IPv4Address.IPAddress
    $MaskBits = (Get-NetIPConfiguration     -InterfaceIndex $interface.InterfaceIndex).IPv4Address.prefixlength
    $Gateway =  (Get-NetRoute               -InterfaceIndex $interface.InterfaceIndex -DestinationPrefix '0.0.0.0/0').NextHop
    $DNS =      (Get-DnsClientServerAddress -InterfaceIndex $interface.InterfaceIndex -AddressFamily $IPType).ServerAddresses

    $IP
    $MaskBits
    $Gateway
    $DNS

    If ($IP) {
        $adapter | Remove-NetIPAddress -AddressFamily $IPType -Confirm:$false
    }

    If ($Gateway) {
        $adapter | Remove-NetRoute -AddressFamily $IPType -Confirm:$false
    }

    $adapter | New-NetIPAddress -AddressFamily $IPType -IPAddress $IP -PrefixLength $MaskBits -DefaultGateway $Gateway
    $adapter | Set-DnsClientServerAddress -ServerAddresses $DNS
    Clear-DnsClientCache

    Write-Output "----------------------------------------"
    $IP =       (Get-NetIPConfiguration     -InterfaceIndex $interface.InterfaceIndex).IPv4Address.IPAddress
    $MaskBits = (Get-NetIPConfiguration     -InterfaceIndex $interface.InterfaceIndex).IPv4Address.prefixlength
    $Gateway =  (Get-NetRoute               -InterfaceIndex $interface.InterfaceIndex -DestinationPrefix '0.0.0.0/0').NextHop
    $DNS =      (Get-DnsClientServerAddress -InterfaceIndex $interface.InterfaceIndex -AddressFamily $IPType).ServerAddresses

    $IP
    $MaskBits
    $Gateway
    $DNS
}
