# Create virtual drive W: to shortcut work folder
$WDrivePath = "$HOME\Music"
if (-Not (Test-Path "W:")) {
	Write-Output "W: folder does not exits, it will be crated in $WDrivePath"
	New-PSDrive -Name W -PSProvider FileSystem -Root $WDrivePath -Description "Work Directory" -Scope Global -Credential (Get-Credential $user)
}
else {
	Write-Output "W: already exists in $WDrivePath"
}

# Create symbolic link to deploy dotfiles
$AlacrittyPath = "$HOME\AppData\Roaming\alacritty"
if (Test-Path -Path $AlacrittyPath) {
	Write-Output "Alacritty folder already exists in $AlacrittyPath, it will be deleted"
	(Get-Item $AlacrittyPath).Delete()
}
Write-Output "Creating Alacritty folder in $AlacrittyPath"
New-Item -ItemType SymbolicLink -Path $AlacrittyPath -Target "./alacritty"