$devicesWithErrors = Get-CimInstance Win32_PnPEntity | Where-Object { $_.ConfigManagerErrorCode -ne 0 } | Select-Object Name, Status, ConfigManagerErrorCode

foreach ($device in $devicesWithErrors) {
    $errorDescription = switch ($device.ConfigManagerErrorCode) {
        1 { "This device is not configured correctly." }
        10 { "This device cannot start." }
        12 { "This device cannot find enough free resources." }
        14 { "This device cannot work properly until you restart your computer." }
        18 { "Reinstall the drivers for this device." }
        19 { "Windows cannot start this hardware device because its configuration information (in the registry) is incomplete or damaged." }
        21 { "Windows is removing this device." }
        22 { "This device is disabled." }
        24 { "This device is not present, is not working properly, or does not have all its drivers installed." }
        28 { "The drivers for this device are not installed." }
        29 { "This device is disabled because the firmware of the device did not give it the required resources." }
        31 { "This device is not working properly because Windows cannot load the drivers required for this device." }
        default { "Unknown error." }
    }
    Write-Output "Device: $($device.Name), Status: $($device.Status), Error: $errorDescription"
}
