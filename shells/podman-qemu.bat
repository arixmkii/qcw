@ECHO OFF

set QCW_DIR=%~dp0..

set PATH=%QCW_DIR%\xz;%LOCALAPPDATA%\Programs\podman-desktop;%PROGRAMFILES%\qemu;%PATH%

set CONTAINERS_MACHINE_PROVIDER=QEMU

set CONTAINERS_HELPER_BINARY_DIR=%QCW_DIR%\podman

cmd /k "ECHO Welcome to Podman with Qemu shell"
