$sourcePath = "C:\Path\To\AdobeupdaterAdminPrefs.dat"
$destinationPath = "C:\Program Files (x86)\Common Files\Adobe\AAMUpdaterInventory\1.0\"

# Check if the source file exists
if (Test-Path $sourcePath -PathType Leaf) {
    # Copy the file to the destination
    Copy-Item -Path $sourcePath -Destination $destinationPath -Force
    Write-Host "File copied successfully."
} else {
    Write-Host "Source file not found. Please make sure the file exists at '$sourcePath'."
}