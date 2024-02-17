# Check if the script is running as administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
   Write-Host "You need to run this script as administrator."
   pause
   exit
}

# Check if the shell used to execute the script is not PowerShell 7
if ($PSVersionTable.PSVersion.Major -lt 7) {
   Write-Host "You need to use PowerShell 7 to execute this script."
   pause
   exit
}

# Set the global execution policy to unrestricted
Set-ExecutionPolicy Unrestricted -Scope LocalMachine -Force

# Check if Chocolatey is installed
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
   # Install Chocolatey
   Set-ExecutionPolicy Bypass -Scope Process -Force
   Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
   Write-Host "Chocolatey is installed."
}
else {
   Write-Host "Chocolatey is already installed."
}

# Check if PowerShell 7 is installed using winget
if (-not (Get-Command pwsh -ErrorAction SilentlyContinue)) {
   # Install PowerShell 7 using winget
   Write-Host "PowerShell 7 is not installed. Installing PowerShell 7..."
   winget install --id Microsoft.PowerShell -e
   Write-Host "PowerShell 7 is installed."
}
else {
   Write-Host "PowerShell 7 is already installed."
}

# Install PowerShellGet and PSReadLine
Write-Host "Installing PowerShellGet and PSReadLine..."
Install-Module -Name PowerShellGet -Force -AllowClobber -Scope AllUsers -Confirm:$false 
Install-Module -Name PSReadLine -Force -AllowClobber -Scope AllUsers -Confirm:$false 
Write-Host "PowerShellGet and PSReadLine are installed."

# # Install the required packages using Chocolatey
# Write-Host "Installing packages using Chocolatey..."
# choco install -y python autohotkey vscode windirstat winfsp nssm brave termius steam notepadplusplus.install gsudo git starship 7zip discord vlc mpv teracopy qbittorrent rclone yt-dlp k-litecodecpackfull revo-uninstaller adb firacode autohotkey nodejs.install curl stremio
# Write-Host "Packages installation completed."

# # Install the required packages using winget
# Write-Host "Installing packages using winget..."
# winget install --id TonecInc.InternetDownloadManager
# winget install --id StardockSoftware.Start10
# winget install --id AppWorkGmbH.JDownloader2
# winget install --id HeroicGamesLauncher.HeroicGamesLauncher
# Write-Host "Packages installation completed."

# Install the required packages from the Windows Store
# Write-Host "Installing packages from the Windows Store..."
# winget install --id HewlettPackard.HPCommandCenter
# winget install --id Microsoft.BatteryPercentageIcon
# winget install --id Microsoft.WinDynamicDesktop
# winget install --id WhatsAppWhatsApp
# winget install --id Viber.Viber
# winget install --id Unigram.Unigram
# Write-Host "Packages installation completed."


# Download the PowerShell profile file
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/aaxyat/WinndowsSetup/main/ConfigFiles/Microsoft.PowerShell_profile.ps1" -OutFile $PROFILE

# Install the profile into PowerShell 7 profile
if ($PSVersionTable.PSVersion.Major -ge 7) {
   $profilePath = $PROFILE | Split-Path
   $profilePath7 = Join-Path $profilePath "Microsoft.PowerShell_profile.ps1"
   Copy-Item -Path $PROFILE -Destination $profilePath7 -Force
   Write-Host "PowerShell 7 profile installed."
}
else {
   Write-Host "PowerShell 7 is not installed. Cannot install the profile."
}

# Download the Windows Terminal settings file
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/aaxyat/WinndowsSetup/main/ConfigFiles/settings.json" -OutFile "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
Write-Host "Windows Terminal settings file downloaded and installed."


# Download the shortcut.exe file
Invoke-WebRequest -Uri "https://github.com/aaxyat/WinndowsSetup/raw/main/ConfigFiles/shortcuts.exe" -OutFile "$env:TEMP\shortcut.exe"

# Copy the shortcut.exe file to shell:startup
$shellStartup = [Environment]::GetFolderPath("Startup")
Copy-Item -Path "$env:TEMP\shortcut.exe" -Destination $shellStartup -Force

Write-Host "shortcut.exe file copied to shell:startup."

# Set the default explorer open folder to "This PC"
$explorerKeyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
Set-ItemProperty -Path $explorerKeyPath -Name "LaunchTo" -Value 1

# Disable "Hide extensions for known file types"
$hideExtensionsKeyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
Set-ItemProperty -Path $hideExtensionsKeyPath -Name "HideFileExt" -Value 0
