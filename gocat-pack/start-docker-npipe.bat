@ECHO OFF

set GOCAT_BIN=%~dp0\gocat

set MACHINE_NAME=podman-machine-default

if NOT [%1]==[] goto makepipe
set MACHINE_NAME=%~1
:makepipe
%GOCAT_BIN% unix-to-npipe dst //./pipe/%MACHINE_NAME% --src %USERPROFILE%\.local\share\containers\podman\machine\%MACHINE_NAME%\podman.sock
