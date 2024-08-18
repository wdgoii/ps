$driverPath = "C:\HP_Color_LaserJet_Managed_MFP_E57540\hpco4A2A4_x64.inf"
## driverName obtido de inf
$driverName = "HP Color LaserJet MFP E57540 PCL-6"
$printerName = "HP_E57540"
$printerPort = "10.112.25.33"
$printerPortName = "TCPPort:10.112.25.33"

if ((get-printer | Where-Object {$_.name -eq $printerName}) -eq $null) {
    
    if ((Get-PrinterDriver | Where-Object {$_.Name -eq $driverName}) -eq $null) {

      pnputil.exe /a $driverPath
      Add-PrinterDriver -Name $driverName
    } else {
      Write-Warning "Printer driver already installed"
    }

    if ((Get-PrinterPort | Where-Object {$_.Name -eq $printerPortName}) -eq $null) {
      # Add printerPort
      Add-PrinterPort -Name $printerPortName -PrinterHostAddress $printerPort
    } else {
      Write-Warning "Printer port with name $($printerPortName) already exists"
    }

    try {
      # Add the printer
      Add-Printer -Name $printerName -DriverName $driverName -PortName $printerPortName -ErrorAction stop
    } catch {
      Write-Host $_.Exception.Message -ForegroundColor Red
      break
    }

    Write-Host "Printer successfully installed" -ForegroundColor Green
    # get-printer | Where-Object {$_.PortName -match '10.112.'} | select name, portname | format-table -AutoSize


} else {
 Write-Warning "Printer already installed"
}