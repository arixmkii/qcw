$target=$args[0]

if ([string]::IsNullOrEmpty($target)) { $target = "qcw-utils" }

if (Test-Path -Path $target) {
    Write-Output "Target forlder '$target' already exists"
    exit 1
}

$defaultBat = @"
@ECHO OFF
set QCW_DIR=%~dp0..
set PATH=%LOCALAPPDATA%\Programs\podman-desktop;%PROGRAMFILES%\qemu;%PATH%
set ELECTRON_NO_ATTACH_CONSOLE=true
cmd /k "ECHO Welcome to Podman shell"
"@

$qemuBat = @"
@ECHO OFF
set QCW_DIR=%~dp0..
set PATH=%LOCALAPPDATA%\Programs\podman-desktop;%PROGRAMFILES%\qemu;%PATH%
set CONTAINERS_MACHINE_PROVIDER=QEMU
set ELECTRON_NO_ATTACH_CONSOLE=true
cmd /k "ECHO Welcome to Podman with QEMU shell"
"@

$wslBat = @"
@ECHO OFF
set QCW_DIR=%~dp0..
set PATH=%LOCALAPPDATA%\Programs\podman-desktop;%PROGRAMFILES%\qemu;%PATH%
set CONTAINERS_MACHINE_PROVIDER=WSL
set ELECTRON_NO_ATTACH_CONSOLE=true
cmd /k "ECHO Welcome to Podman with WSL shell"
"@

$hypervBat = @"
@ECHO OFF
set QCW_DIR=%~dp0..
set PATH=%LOCALAPPDATA%\Programs\podman-desktop;%PROGRAMFILES%\qemu;%PATH%
set CONTAINERS_MACHINE_PROVIDER=HYPERV
set ELECTRON_NO_ATTACH_CONSOLE=true
cmd /k "ECHO Welcome to Podman with HYPERV shell"
"@

$shellsTarget = Join-Path $target "shells"
New-Item -Path $target -ItemType Directory | Out-Null

New-Item -Path $shellsTarget -ItemType Directory | Out-Null
New-Item -Path $shellsTarget -Name "podman-default.bat" -ItemType File -Value $defaultBat | Out-Null
New-Item -Path $shellsTarget -Name "podman-qemu.bat" -ItemType File -Value $qemuBat | Out-Null
New-Item -Path $shellsTarget -Name "podman-wsl.bat" -ItemType File -Value $wslBat | Out-Null
New-Item -Path $shellsTarget -Name "podman-hyperv.bat" -ItemType File -Value $hypervBat | Out-Null

Write-Output "'qcw-utils' to '$target' folder installation completed"
