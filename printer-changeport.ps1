$printer_name = "<Printer Name Here>"
$new_PortName = "IP_192.168.0.1"

#Save printer in Object
$get_print = Get-Printer | Where-Object -Property Name -Match $printer_name

#Remove Printer
remove-printer $($get_print.Name)
remove-printerPort -Name $($get_print.PortName)

#Change PortName from object
$get_print.PortName = "$new_PortName"

#Install Printer again
Add-PrinterDriver -Name $($get_print.DriverName)
Add-PrinterPort -Name $($get_print.PortName) -PrinterHostAddress $($get_print.PortName -Replace 'IP_','')
Add-Printer -Name $($get_print.Name) -PortName $($get_print.PortName) -DriverName $($get_print.DriverName)