# Specify the new server domain
$newServerDomain = "smcprint.stowers.com"

# Get all the installed printers
$printers = Get-WmiObject -Query "Select * From Win32_Printer"

# Loop through each printer
foreach ($printer in $printers) {
    # Ignore local printers
    if ($printer.Network -eq $true) {
        # Get the printer's name
        $printerName = $printer.Name

        # Create the new printer path
        $newPrinterPath = "\\$newServerDomain\" + $printerName.Split("\")[-1]

        # Delete the old printer
        (New-Object -ComObject WScript.Network).RemovePrinterConnection($printerName)

        # Add the new printer
        (New-Object -ComObject WScript.Network).AddWindowsPrinterConnection($newPrinterPath)

        Write-Host "Printer $printerName has been reconfigured to $newPrinterPath."
    }
}
