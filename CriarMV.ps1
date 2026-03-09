Set-ExecutionPolicy -ExecutionPolicy  Bypass -Scope CurrentUser

$vmName = "Windows11-VM01"
$vmPath = "D:\VMs\$vmName"
$vhdPath = "$vmPath\$vmName.vhdx"
$isoPath = "D:\isos\Windows11.iso" # Altere para o caminho da sua ISO

stop-vm -Name $vmName
Remove-VM -Name $vmName -Force
Remove-Item $vmPath -Recurse -Force


# Cria a pasta de destino
New-Item -Path $vmPath -ItemType Directory

# Cria a VM e o disco virtual
New-VM -Name $vmName -MemoryStartupBytes 6GB -BootDevice VHD -NewVHDPath $vhdPath -NewVHDSizeBytes 64GB -Path $vmPath -Generation 2

Set-VM -Name $vmName -ProcessorCount 2 -DynamicMemory -MemoryMinimumBytes 1GB -MemoryMaximumBytes 8GB

# Adiciona o drive de DVD com a ISO
Add-VMDvdDrive -VMName $vmName -Path $isoPath

# Define o DVD como o primeiro dispositivo de boot
$dvdDrive = Get-VMDvdDrive -VMName $vmName
Set-VMFirmware -VMName $vmName -FirstBootDevice $dvdDrive

# 1. Ativa o TPM Virtual (Obrigatório para Windows 11)
#Enable-VMTerminology -VMName $vmName  # Apenas se o comando abaixo falhar em versões antigas
#Set-VMKeyProtector -VMName $vmName -NewLocalKeyProtector
#Set-VMSecurity -VMName $vmName -EncryptStateAndVMStorageTraffic $true -EnableTPM $true

# 2. Garante que o Secure Boot use o template correto da Microsoft
Set-VMFirmware -VMName $vmName -EnableSecureBoot Off

# Agora sim, inicie
Start-VM -Name $vmName
vmconnect.exe localhost $vmName