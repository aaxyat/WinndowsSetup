# Check if the script is running as administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
   Write-Host "You need to run this script as administrator."
   pause
   exit
}

# Define the log file path
$logDir = "$HOME\Documents\logs"
$logFile = "$logDir\setup.log"


# Create the logs directory if it doesn't exist
if (!(Test-Path -Path $logDir)) {
   New-Item -ItemType Directory -Force -Path $logDir
}

# Start the transcript
Start-Transcript -Path $logFile -Append


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
   winget install  --accept-source-agreements --accept-package-agreements -e --id Microsoft.PowerShell 
   Write-Host "PowerShell 7 is installed."
}
else {
   Write-Host "PowerShell 7 is already installed."
}

# Check if the shell used to execute the script is not PowerShell 7
if ($PSVersionTable.PSVersion.Major -lt 7) {
   Write-Host "You need to use PowerShell 7 to execute this script."
   pause
   exit
}

# Install PowerShellGet and PSReadLine
Write-Host "Installing PowerShellGet and PSReadLine..."
Install-Module -Name PowerShellGet -Force -AllowClobber -Scope AllUsers -Confirm:$false 
Install-Module -Name PSReadLine -Force -AllowClobber -Scope AllUsers -Confirm:$false 
Write-Host "PowerShellGet and PSReadLine are installed."

# # Install the required packages using Chocolatey

$packages = @(,"fzf", "zoxide", "python", "autohotkey", "windirstat", "winfsp", "nssm", "termius", "notepadplusplus.install", "gsudo", "git", "starship",  "vlc", "mpv", "teracopy", "qbittorrent", "rclone", "yt-dlp", "k-litecodecpackfull", "revo-uninstaller", "adb", "firacode", "nodejs.install", "curl", "stremio")
$totalPackages = $packages.Count

Write-Host "Installing packages using Chocolatey..."

for ($i = 0; $i -lt $totalPackages; $i++) {
   Write-Host "Installing package $($i+1)/${totalPackages}: $($packages[$i])"
   choco install -y $($packages[$i])
}

Write-Host "Packages installation completed."

# # Install the required packages using winget
Write-Host "Installing packages using winget..."
winget install --accept-package-agreements -e --id Brave.Brave
winget install --accept-package-agreements -e --id Giorgiotani.Peazip 
winget install --accept-package-agreements -e --id Tonec.InternetDownloadManager
winget install --accept-package-agreements -e --id StartIsBack.StartAllBack
# winget install --accept-package-agreements -e --id AppWork.JDownloader
# winget install --accept-package-agreements -e --id HeroicGamesLauncher.HeroicGamesLauncher
winget install --accept-package-agreements -e --id Bitwarden.Bitwarden
winget install --accept-package-agreements -e --id Bitwarden.CLI
# winget install --accept-package-agreements -e --id JetBrains.Toolbox
winget install --accept-package-agreements -e --id pCloudAG.pCloudDrive
winget install --accept-package-agreements -e --id WireGuard.WireGuard
winget install --accept-package-agreements -e --id Mozilla.Firefox
winget install --accept-package-agreements -e --id GitHub.GitHubDesktop
winget install --accept-package-agreements -e --id tailscale.tailscale
# winget install --accept-package-agreements -e --id Axosoft.GitKraken
# winget install --accept-package-agreements -e --id TechNobo.TcNoAccountSwitcher
# winget install --accept-package-agreements -e --id hluk.CopyQ
winget install --accept-package-agreements -e --id Valve.Steam
# winget install --accept-package-agreements -e --id Microsoft.PowerToys
winget install --accept-package-agreements -e --id voidtools.Everything
# winget install --accept-package-agreements -e --id lin-ycv.EverythingPowerToys
# winget install --accept-package-agreements -e --id RadolynLabs.AyuGramDesktop
winget install --accept-package-agreements -e --id Microsoft.VisualStudioCode
winget install --accept-package-agreements -e --id IPVanish.IPVanish 
# winget install --accept-package-agreements -e --id SoftDeluxe.FreeDownloadManager #Free Download Manager
# winget install --accept-package-agreements -e --id spacedrive.Spacedrive
# winget install --accept-package-agreements -e --id wez.wezterm



Write-Host "Packages installation completed."

# Install the required packages from the Windows Store
Write-Host "Installing packages from the Windows Store..."
winget install --accept-package-agreements --id 9P92N00QV14J # HP Command Center
# winget install --accept-package-agreements --id 9PCKT2B7DZMW # Battery Percentage icon
winget install --accept-package-agreements --id 9NM8N7DQ3Z5F # WinDynamicDesktop
winget install --accept-package-agreements --id 9NKSQGP7F2NH # Whatsapp
winget install --accept-package-agreements --id XPFM5P5KDWF0JP # Viber
# winget install --accept-package-agreements --id 9N97ZCKPD60Q # Unigram
# winget install --accept-package-agreements --id 9ncrcvjc50wl # WinnowMail
winget install --accept-package-agreements --id 9n0dx20hk701 # Windows Terminal
# winget install --accept-package-agreements --id 9PMHZVM588P4 #Bluemail
Write-Host "Packages installation completed."


# Download the PowerShell profile file

# Install the profile into PowerShell 7 profile
if ($PSVersionTable.PSVersion.Major -ge 7) {
   Invoke-WebRequest -Uri "https://raw.githubusercontent.com/aaxyat/WindowsSetup/main/ConfigFiles/Microsoft.PowerShell_profile.ps1" -OutFile $PROFILE

   # $profilePath = $PROFILE | Split-Path
   # $profilePath7 = Join-Path $profilePath "Microsoft.PowerShell_profile.ps1"
   # Copy-Item -Path $PROFILE -Destination $profilePath7 -Force
   Write-Host "PowerShell 7 profile installed."
}
else {
   Write-Host "PowerShell 7 is not installed. Cannot install the profile."
}

# Download the Windows Terminal settings file
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/aaxyat/WindowsSetup/main/ConfigFiles/settings.json" -OutFile "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
Write-Host "Windows Terminal settings file downloaded and installed."


# Download the shortcut.exe file
Invoke-WebRequest -Uri "https://github.com/aaxyat/WindowsSetup/raw/main/ConfigFiles/shortcuts.exe" -OutFile "$env:TEMP\shortcut.exe"

# Copy the shortcut.exe file to shell:startup
$shellStartup = [Environment]::GetFolderPath("Startup")
Copy-Item -Path "$env:TEMP\shortcut.exe" -Destination $shellStartup -Force

Write-Host "shortcut.exe file copied to shell:startup."

# Download the starship.toml file and install it
$url = "https://github.com/aaxyat/WindowsSetup/raw/main/ConfigFiles/starship.toml"
$destDir = "$HOME\.config\"
$destFile = "$destDir\starship.toml"

# Create the directory if it doesn't exist
if (!(Test-Path -Path $destDir)) {
   New-Item -ItemType Directory -Force -Path $destDir
}

# Download the file
Invoke-WebRequest -Uri $url -OutFile $destFile

# Set the default explorer open folder to "This PC"
$explorerKeyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
Set-ItemProperty -Path $explorerKeyPath -Name "LaunchTo" -Value 1

# Disable "Hide extensions for known file types"
$hideExtensionsKeyPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
Set-ItemProperty -Path $hideExtensionsKeyPath -Name "HideFileExt" -Value 0

# Download and install Office
Write-Host "Downloading and installing Office..."
$officeUrl = "https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=O365ProPlusRetail&platform=x64&language=en-us&version=O16GA"
$officeInstallerPath = "$env:TEMP\OfficeInstaller.exe"
Invoke-WebRequest -Uri $officeUrl -OutFile $officeInstallerPath
Start-Process -FilePath $officeInstallerPath -Wait
Write-Host "Office installation completed."

# Create the Github folder if it doesn't exist
$githubFolder = Join-Path $HOME\Documents "Github"
if (!(Test-Path -Path $githubFolder)) {
   New-Item -ItemType Directory -Force -Path $githubFolder
}

# Install Ubuntu
wsl --install -d Ubuntu


# Stop the transcript at the end of the script
Stop-Transcript


