@ECHO OFF

set QCW_DIR=%~dp0..

set PATH=%QCW_DIR%\qemu;%QCW_DIR%\xz;%QCW_DIR%\podman;%LOCALAPPDATA%\Programs\podman-desktop;%PATH%

set CONTAINERS_MACHINE_PROVIDER=WSL

set CONTAINERS_HELPER_BINARY_DIR=%QCW_DIR%\podman

cmd /k "ECHO Welcome to Podman with WSL shell"
