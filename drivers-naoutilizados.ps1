$allDrivers = Get-CimInstance Win32_PnPSignedDriver
$installedDevices = Get-CimInstance Win32_PnPEntity

$unusedDrivers = $allDrivers | Where-Object { $driver = $_  -not ($installedDevices | Where-Object { $_.DeviceID -eq $driver.DeviceID })}


$unusedDrivers | Select-Object DeviceName, DriverVersion, InfName, Manufacturer, DriverProviderName