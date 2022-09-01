@ECHO OFF

set GOCAT_BIN=%~dp0\gocat

set MACHINE_NAME=%~1

if NOT ["%MACHINE_NAME%"]==[""] goto makepipe
set MACHINE_NAME=podman-machine-default
:makepipe
start cmd /K "%GOCAT_BIN% unix-to-npipe --sdst //./pipe/%MACHINE_NAME% --src %USERPROFILE%\.local\share\containers\podman\machine\%MACHINE_NAME%\podman.sock"
