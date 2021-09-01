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


# Intall Windows fonts
$FontFolder = ".\fonts\Hack Nerd Font Windows"
Write-Output "`n- Install fonts from $FontFolder"
$FontItem = Get-Item -Path $FontFolder
$FontList = Get-ChildItem -Path "$FontItem\*" -Include ('*.fon', '*.otf', '*.ttc', '*.ttf')
foreach ($Font in $FontList) {
	# TODO - Only install missing fonts
	Write-Output '`tInstalling font -' $Font.BaseName
	Copy-Item $Font "C:\Windows\Fonts"
	New-ItemProperty -Name $Font.BaseName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -PropertyType string -Value $Font.name
}
$FontFolder = ".\fonts\\CascadiaCode"
Write-Output "`n- Install fonts from $FontFolder"
$FontItem = Get-Item -Path $FontFolder
$FontList = Get-ChildItem -Path "$FontItem\*" -Include ('*.fon', '*.otf', '*.ttc', '*.ttf')
foreach ($Font in $FontList) {
	# TODO - Only install missing fonts
	Write-Output '`tInstalling font -' $Font.BaseName
	Copy-Item $Font "C:\Windows\Fonts"
	New-ItemProperty -Name $Font.BaseName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -PropertyType string -Value $Font.name
}


# Create symbolic link to deploy Alacritty dotfiles
$AlacrittyPath = "$HOME\AppData\Roaming\alacritty\"
Write-Output "`n- Install Alacritty configuration in $AlacrittyPath"

if (Test-Path -Path $AlacrittyPath) {
	Write-Output "`tAlacritty folder already exists in $AlacrittyPath, it will be deleted"
	# TODO - Check if there is already a non symbolic folder
	(Get-Item $AlacrittyPath).Delete()
}
Write-Output "`tCreating Alacritty folder in $AlacrittyPath"
New-Item -ItemType SymbolicLink -Path $AlacrittyPath -Target "./alacritty"


# Create symbolic link to deploy Alacritty dotfiles
$NvimPath = "$HOME\AppData\Local\nvim"
Write-Output "`n- Install Alacritty configuration in $NvimPath"

if (Test-Path -Path $NvimPath) {
	Write-Output "`tNvim folder already exists in $NvimPath, it will be deleted"
	# TODO - Check if there is already a non symbolic folder
	(Get-Item $NvimPath).Delete()
}
Write-Output "`tCreating Nvim folder in $NvimPath"
New-Item -ItemType SymbolicLink -Path $NvimPath -Target "./nvim"

# Install NeoVim package manager - Packer
$PackerFolder = "$env:LOCALAPPDATA\nvim-data\site\pack\packer\start\"
if (Test-Path -Path $NvimPath) {
	(Get-Item $PackerFolder).Delete()
	git clone https://github.com/wbthomason/packer.nvim "$PackerFolder\packer.nvim"
}
