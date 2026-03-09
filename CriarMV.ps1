Set-ExecutionPolicy -ExecutionPolicy  Bypass -Scope CurrentUser
$vmName = "Windows11-VM01"
$vmPath = "D:\VMs\$vmName"
$vhdPath = "$vmPath\$vmName.vhdx"
$isoPath = "D:\isos\Windows11.iso" # Altere para o caminho da sua ISO

# Cria a pasta de destino
New-Item -Path $vmPath -ItemType Directory

# Cria a VM e o disco virtual
New-VM -Name $vmName -MemoryStartupBytes 6GB -BootDevice VHD -NewVHDPath $vhdPath -NewVHDSizeBytes 40GB -Path $vmPath -Generation 2

Set-VM -Name $vmName -ProcessorCount 2 -DynamicMemory -MemoryMinimumBytes 1GB -MemoryMaximumBytes 4GB

# Adiciona o drive de DVD com a ISO
Add-VMDvdDrive -VMName $vmName -Path $isoPath

# Define o DVD como o primeiro dispositivo de boot
$dvd = Get-VMDvdDrive -VMName $vmName
Set-VMBootOrder -VMName $vmName -FirstByDevice $dvd

Start-VM -Name $vmName
vmconnect.exe localhost $vmName