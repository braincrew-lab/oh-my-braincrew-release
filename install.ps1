# oh-my-braincrew installer for Windows
# Usage: irm https://raw.githubusercontent.com/teddynote-lab/oh-my-braincrew-release/main/install.ps1 | iex

$ErrorActionPreference = "Stop"

$Repo = "teddynote-lab/oh-my-braincrew-release"
$BinaryName = "omb.exe"

# --- Install directory ---
$InstallDir = if ($env:OMB_INSTALL_DIR) { $env:OMB_INSTALL_DIR } else { "$env:LOCALAPPDATA\omb\bin" }

# --- Detect architecture ---
$Arch = if ([System.Environment]::Is64BitOperatingSystem) { "amd64" } else {
    Write-Error "32-bit Windows is not supported."
    exit 1
}

# --- Fetch latest version ---
Write-Host "Checking for latest version..."
$ApiUrl = "https://api.github.com/repos/$Repo/releases/latest"
$Release = Invoke-RestMethod -Uri $ApiUrl -Headers @{ Accept = "application/vnd.github+json" }
$Version = $Release.tag_name -replace "^v", ""

if (-not $Version) {
    Write-Error "Could not determine latest version."
    exit 1
}

# --- Download ---
$AssetName = "omb-v${Version}-windows-${Arch}.exe"
$DownloadUrl = "https://github.com/$Repo/releases/download/v${Version}/$AssetName"

Write-Host "Installing omb v${Version} (windows/${Arch})..."

$TmpFile = Join-Path $env:TEMP "omb_download.exe"

Invoke-WebRequest -Uri $DownloadUrl -OutFile $TmpFile -UseBasicParsing

# --- Install ---
if (-not (Test-Path $InstallDir)) {
    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
}

$DestPath = Join-Path $InstallDir $BinaryName
Move-Item -Path $TmpFile -Destination $DestPath -Force

# --- Add to PATH if not already there ---
$UserPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
if ($UserPath -notlike "*$InstallDir*") {
    [System.Environment]::SetEnvironmentVariable("Path", "$UserPath;$InstallDir", "User")
    Write-Host ""
    Write-Host "Added $InstallDir to your PATH."
    Write-Host "Restart your terminal for the PATH change to take effect."
}

Write-Host ""
Write-Host "omb v${Version} installed to $DestPath"
Write-Host ""
Write-Host "Run 'omb version' to verify."
