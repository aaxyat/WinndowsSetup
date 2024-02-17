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



