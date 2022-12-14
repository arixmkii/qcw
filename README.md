# qcw

QEMU Containers for Windows

## About the project

This project contains patches and build scripts to create binary distributions of the software for running containers
on Windows using QEMU virtualization. It started in the scope of the discussion of the
[issue](https://github.com/containers/podman/issues/13006) in Podman project.

The aim is to maintain rebuilds with a minimal set of changes to all needed projects and later to archive it or this
project would become an instruction on how to build that kind of setup using released versions.

All thanks goes and attribution stays with the authours of the great pieces of software, which made this project
possible in the first place.

## Specific requirements

This is built for relatively fresh Windows systems, which has unix domain sockets support. The suport was announced
starting with Windows 10 Insiders build in late 2017: https://devblogs.microsoft.com/commandline/af_unix-comes-to-windows/
It will also require [Hyper-V](https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/about/) support by
default. It could be possible to run VM using [Intel HAXM](https://github.com/intel/haxm), but this should be treated
as even more experimental.

## Included software

Ordered alphabetically

* `gocat` - [Github](https://github.com/sumup-oss/gocat) multipurpose networking relay;
* `gvisor-tap-vsock` - [Github](https://github.com/containers/gvisor-tap-vsock) the tool to provide networking for
accessing containers from Windows;
* `Podman` - [home page](https://podman.io/) and [Github](https://github.com/containers/podman) free and open source
container runtime;
* `Podman Desktop` - [home page](https://podman-desktop.io/) and [Github](https://github.com/containers/podman-desktop)
GUI companion to Podman;
* `QEMU` - [home page](https://www.qemu.org/) and [Github (mirror)](https://github.com/qemu/qemu) free and open source
feature rich machine emulator;
* `XZ Utils` - [home page](https://tukaani.org/xz/) compression utilities.

### Versions and patches

#### `gocat`

Built from HEAD of the development branch. Added patch with updated dependencies.

#### `gvisor-tap-vsock`

Version `0.5.0` is used.

#### `Podman`

Version `4.4.0-dev` with a patch to enable using QEMU machine on Windows hosts. This is continuous work trying
to upstream the changes, where possible. At the end this should come down to a single patch on top on a stable tag.
Supposed to be a long living patchwork, because needs full support for some features on QEMU side (see QEMU specific
patches).

#### `Podman Desktop`

Latest version (or stable later than v0.0.6) is a requirement. Should be installed via official setup mechanism.

#### `QEMU`

Starting from version `0.0.6` of qcw it is possible to use with official windows builds of QEMU (if host FS mounts
are not needed).

Version `7.2.0` with 2 patch sets from QEMU mailing list:
* enable 9pfs on Windows;
* workaround for readonly plflash.

Both patches have numerous reviews already and probably will move forward in the next release window.

#### `XZ Utils`

Version `5.2.9` w/o any changes.

## How to use Podman

### Basics

Download installation packages of the release. Install qemu and podman using their installers. Then install
`qcw-utils` in the desired directory using
`powershell -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/arixmkii/qcw/main/qcw-utils.ps1'))"` or
`pwsh -c "iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/arixmkii/qcw/main/qcw-utils.ps1'))"`
(each release will have tagged version of this utility as well if
one wants more control over tools version). You will have preconfigured shell launchers under `.\qcw-utils\shells\`
when installation completes.

Then run the podman machine init command as one would do with all other podman installations. The catch is to give
2 mandatory config overrides:
```bat
podman machine init --image-path testing --username core
```

* `--image-path` is mandatory to allow podman to donwload default (non WSL2) image for the machine (overriding the
behavior of WSL2 option, which is dominant);
* `--username` is needed as FCOS image is using different username than Fedora used in WSL2 (again overridind WSL2
defaults).

All other options (except virtfs volume mounts) from QEMU on MacOS/Linux should work, so, one should be able to
tweak the machine to the needed performance requirements.

Then run the machine as normal
```bat
podman machine start
```

Then start your first container with

```bat
podman run -d --rm -p 8080:80 nginx
```

And test it with `curl`

```bat
curl http://localhost:8080
```

### With Podman Desktop

One needs to install latest Podman Desktop (v0.0.7 or newer) to use it with QEMU machine. The important requirement
is that there should not be official Podman installation in the same system (because Podman Desktop will allways use
it with if found). It is enough to just call the application from the shell and it will connect.

To run Podman Desktop call this inside shell (`"` are important because of the app name having whitespace):
```bat
start cmd /C "Podman Desktop"
```

`start cmd /C` is needed for Podman Desktop not to lock your terminal. More info: https://github.com/containers/podman-desktop/issues/1050

## How to use Lima

TBD

## Known issues Podman

### 1. Name collisions between QEMU and WSL2

Machines are fully isolated, but the ssh public/private key naming scheme is not, so, if machine names are the same,
then only one of them would have valid keys. Workaround is not to use default names for machines if user plans to use
both QEMU and WSL.

### 2. Sometimes sock files are not cleaned up (if somethign crashes)

There could be lefovers in `%TEMP%\podman`, which prevents `QEMU` or `gvproxy` startup. Solution is to shutdown machine
and then cleanup this location manually before starting again.

## Known issues Lima

### 1. TBD

TBD
