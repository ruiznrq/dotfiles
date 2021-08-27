# Create virtual drive W: to shortcut work folder
$WDrivePath = "$HOME\Music\"
Write-Output "`n- Create W: virtual drive in $WDrivePath"

if (-Not (Test-Path "W:")) {
	Write-Output "`tW: drive does not exits, it will be crated in $WDrivePath"
	New-PSDrive -Name W -PSProvider FileSystem -Root $WDrivePath -Description "Work Directory" -Scope Global -Credential (Get-Credential $user)
}
else {
	Write-Output "`tW: drive already exists in $WDrivePath"
}


# Create symbolic link to deploy dotfiles
$AlacrittyPath = "$HOME\AppData\Roaming\alacritty\"
Write-Output "`n- Install Alacritty configuration in $AlacrittyPath"

if (Test-Path -Path $AlacrittyPath) {
	Write-Output "`tAlacritty folder already exists in $AlacrittyPath, it will be deleted"
	Get-ChildItem -Path $AlacrittyPath * -Recurse | Remove-Item
	(Get-Item $AlacrittyPath).Delete()
}
Write-Output "`tCreating Alacritty folder in $AlacrittyPath"
New-Item -ItemType SymbolicLink -Path $AlacrittyPath -Target "./alacritty"