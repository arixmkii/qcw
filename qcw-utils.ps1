$target=$args[0]

if ([string]::IsNullOrEmpty($target)) { $target = "qcw-utils" }

if (Test-Path -Path $target) {
    Write-Output "Target forlder '$target' already exists"
    exit 1
}


$qemuBat = @"
@ECHO OFF
set QCW_DIR=%~dp0..
set PATH=%QCW_DIR%\xz;%LOCALAPPDATA%\Programs\podman-desktop;%PROGRAMFILES%\qemu;%PATH%
set CONTAINERS_MACHINE_PROVIDER=QEMU
cmd /k "ECHO Welcome to Podman with Qemu shell"
"@

$wslBat = @"
@ECHO OFF
set QCW_DIR=%~dp0..
set PATH=%QCW_DIR%\xz;%LOCALAPPDATA%\Programs\podman-desktop;%PATH%
set CONTAINERS_MACHINE_PROVIDER=WSL
cmd /k "ECHO Welcome to Podman with WSL shell"
"@


$shellsTarget = Join-Path $target "shells"
$xzTarget = Join-Path $target "xz"
New-Item -Path $target -ItemType Directory | Out-Null

New-Item -Path $shellsTarget -ItemType Directory | Out-Null
New-Item -Path $shellsTarget -Name "podman-qemu.bat" -ItemType File -Value $qemuBat | Out-Null
New-Item -Path $shellsTarget -Name "podman-wsl.bat" -ItemType File -Value $wslBat | Out-Null

$xzUrl = "https://tukaani.org/xz/xz-5.2.9-windows.zip"
$xzDl = New-TemporaryFile
$xzExpand = New-TemporaryFile
Invoke-WebRequest -Uri $xzUrl -OutFile ($xzDl.FullName + ".zip")
Remove-Item $xzExpand.FullName
Expand-Archive ($xzDl.FullName + ".zip") -DestinationPath $xzExpand.FullName
$xzBin = Join-Path $xzExpand "bin_x86-64"
Copy-Item $xzBin $xzTarget -Recurse

Write-Output "'qcw-utils' to '$target' folder installation completed"
