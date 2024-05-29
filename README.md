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
default.

## Included software

Ordered alphabetically

* `gocat` - [Github](https://github.com/sumup-oss/gocat) multipurpose networking relay;
* `gvisor-tap-vsock` - [Github](https://github.com/containers/gvisor-tap-vsock) the tool to provide networking for
accessing containers from Windows;
* `OpenSSH` - [home page](https://www.openssh.com/) SSH connectivity tool fork from [Powershell Github](https://github.com/PowerShell/openssh-portable);
* `Podman` - [home page](https://podman.io/) and [Github](https://github.com/containers/podman) free and open source
container runtime;
* `Podman Desktop` - [home page](https://podman-desktop.io/) and [Github](https://github.com/containers/podman-desktop)
GUI companion to Podman;
* `QEMU` - [home page](https://www.qemu.org/) and [Github (mirror)](https://github.com/qemu/qemu) free and open source
feature rich machine emulator;
* `Zlib` - [home page](https://www.zlib.net/) compression library.

### Versions and patches

#### `gocat`

Built from HEAD of the development branch. Added patch with updated dependencies.

#### `gvisor-tap-vsock`

Version bundled with Podman is used

#### `OpenSSH`

Version `v9.5.0.0` with 1 patch from Powershell OpenSSH fork PRs:
* Add support for AF_UNIX https://github.com/PowerShell/openssh-portable/pull/674

#### `Podman`

Version `5.2.0-dev` with TBD patch sets from Podman PRs:
* TBD

#### `Podman Desktop`

Latest version (or stable later than v0.0.12) is a requirement. Should be installed via official setup mechanism.

#### `QEMU`

Starting from version `0.0.6` of qcw it is possible to use with official windows builds of QEMU (if host FS mounts
are not needed).

Version `9.0.0` with 3 patch sets from QEMU mailing list:
* hw/9pfs: Add 9pfs support for Windows https://lists.gnu.org/archive/html/qemu-devel/2023-02/msg05533.html;
* WHPX: Add support for device backed memory regions https://lists.gnu.org/archive/html/qemu-devel/2022-07/msg04837.html;
* Windows installer: keep dependency cache https://lists.gnu.org/archive/html/qemu-devel/2023-01/msg03125.html.

#### `Zlib`

Version `1.3` with 2 patches from main after release and from Powershell fork:
* Add vc17 support
* Set Multibyte character set and spectre mitigation

## How to use QEMU

It is packaged the way similar to official builds, one can just follow official installation instructions. Changed from official
buids are considered unstable and discouraged to be used on their own. This is why no additional manual is provided.

## How to use Podman

### Basics

Download installation packages of the release. Install QEMU and Podman using their installers. Then install
`qcw-utils` in the desired directory using
`powershell -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/arixmkii/qcw/main/qcw-utils.ps1'))"` or
`pwsh -c "iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/arixmkii/qcw/main/qcw-utils.ps1'))"`
(each release will have tagged version of this utility as well if
one wants more control over tools version). One will have preconfigured shell launchers under `.\qcw-utils\shells\`
when installation completes. When using `podman-default.bat` one needs to configure machine provider in
`%APPDATA%\containers\containers.conf` setting `provider = "qemu"` or `provider = "wsl"` inside `[machine]` section.

**This is needed temporary until it is added to Podman installation itself**

Add `C:\etc\containers\policy.json` with content
```json
{
    "default": [
        {
            "type": "insecureAcceptAnything"
        }
    ]
}
```

Then run the Podman machine init command as one would do with all other Podman installations. The catch is to give
2 mandatory config overrides:
```bat
podman machine init --image-path testing --username core
```

* `--image-path` is mandatory to allow Podman to donwload default (non WSL2) image for the machine (overriding the
behavior of WSL2 option, which is dominant);
* `--username` is needed as FCOS image is using different username than Fedora used in WSL2 (again overridind WSL2
defaults).

All other options (except virtfs volume mounts) from QEMU on MacOS/Linux should work the same way, so, one should be able to
tweak the machine to the needed performance requirements.

To use filemounts on Windows (works only with the patched version of QEMU). Need to use Windows path in the source position
defining every volume, for example `-v C:\Temp\Storage:/home/core/storage`. There is automatic conversion in place, so,
`-v C:\Temp\Storage` is equal to `-v C:\Temp\Storage:/C/Temp/Storage`. Then using mounting the shared FS into container
one needs to reference it using mapped target path. Having this mount `-v C:\Temp\Storage:/home/core/storage`, to Mount
`C:\Temp\Storage\static` into container `/var/static` one would need to add `-v /home/core/storage/static:/var/static` to
`podman run` command arguments.

Then run the machine as normal
```bat
podman machine start
```

Then start the first container with

```bat
podman run -d --rm -p 8080:80 nginx
```

And test it with `curl`

```bat
curl http://localhost:8080
```

### With Podman Desktop

One needs to install latest Podman Desktop (v0.0.12 or newer) to use it with QEMU machine. Running Podman Desktop as
usual (not from either of shells) will launch application ready to connect to the machine with the provider specified in
`containers.conf` file. Launching application from provided shell, will select QEMU or WSL flavor of Podman machine
matching the behavior of the command line tool.

To run Podman Desktop call this inside shell (`"` are important because of the app name having whitespace):
```bat
"Podman Desktop"
```

### Inside Hyper-V VM

It is possible to run Podman with QEMU machine inside Hyper-V VM with nested virtualization enabled. On how to enable
nested virtualization one should follow [official MS guide](https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/user-guide/enable-nested-virtualization). It is users responsibility to allocated enough resources for the VM to host a Podman machine of the expected
size. If VM is configured correctly and the HW requirements for nested vitrualization are met, then workflow to run
Podman machine should be the same as on bare metal (the performance is expected to be worse to some extent, because
it runs inside a VM).

## How to use Lima

TBD

## Known issues QEMU

### 1. Incomplete 9pfs implmenetation

The patch used to enable 9pfs is a work in progress. Some of the functionality is missing or is unstable:
* it is impossible to enumerate content of directories containing Windows symlinks;
* it is impossible to enumerate content of directories containing Windows Unix domain socket records;
* non determenistic access denied could be thrown on file overwrites because of some internal races.

## Known issues Podman

### 1. Sometimes sock files are not cleaned up (if somethign crashes)

There could be leftovers in `%TEMP%\podman`, which prevents `QEMU` or `gvproxy` startup. Solution is to shutdown machine
and then clean up this location manually before starting again.

## Known issues Lima

### 1. TBD

TBD
