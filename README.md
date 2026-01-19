# qcw

QEMU Containers for Windows

## About the project

This project contains patches and build scripts to create binary distributions of the software for running containers
on Windows using QEMU virtualization. It started in the scope of the discussion of the
[issue](https://github.com/containers/podman/issues/13006) in Podman project.

The aim is to maintain rebuilds with a minimal set of changes to all needed projects and later to archive it or this
project would become an instruction on how to build that kind of setup using released versions.

All thanks go and attribution stays with the authours of the great pieces of software, which made this project
possible in the first place.

## License

The build and setup scripts in this repository are licensed under Apache-2.0 license, but the patches and the original software
being patched and rebuilt keeps its original license in effect. This project doesn't change how the rebuilt software is licensed.

## Specific requirements

This is built for relatively fresh Windows systems, which has unix domain sockets support. The suport was announced
starting with Windows 10 Insiders build in late 2017: https://devblogs.microsoft.com/commandline/af_unix-comes-to-windows/
It will also require [Hyper-V](https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/about/) support by
default.

Some features require even more fresh Windows systems. To baseline would be a Windows system with `WSL` version `2.6.1`.

It is also recommended to allow inbound connections in Hyper-V firewall to not interfere with port forwarding from inside Lima
```powershell
Set-NetFirewallHyperVVMSetting -Name '{40E0AC32-46A5-438A-A0B2-2B479E8F2E90}' -DefaultInboundAction Allow
```

## Included software

Ordered alphabetically

* `AlpineWSL` - [GitHub](https://github.com/yuk7/AlpineWSL) Alpine Linux based WSL distribution;
* `docker-cli` - [GitHub](https://github.com/docker/cli) `docker` command line interface;
* `docker-compose` - [GitHub](https://github.com/docker/compose) orchestration tool for containers;
* `gvisor-tap-vsock` - [GitHub](https://github.com/containers/gvisor-tap-vsock) the tool to provide networking for
accessing containers from Windows;
* `go-wsllinks` - [GitHub](https://github.com/arixmkii/go-wsllinks) symlink like binaries for WSL2;
* `Lima` - [home page](https://lima-vm.io/) and [GitHub](https://github.com/lima-vm/lima) Linux virtual machines, with a focus on running containers;
* `Podman` - [home page](https://podman.io/) and [GitHub](https://github.com/containers/podman) free and open source
container runtime;
* `Podman Desktop` - [home page](https://podman-desktop.io/) and [GitHub](https://github.com/containers/podman-desktop)
GUI companion to Podman;
* `QEMU` - [home page](https://www.qemu.org/) and [GitHub (mirror)](https://github.com/qemu/qemu) free and open source
feature rich machine emulator;
* `sshocker` - [GitHub](https://github.com/lima-vm/sshocker) ssh + reverse sshfs + port forwarder, in Docker-like CLI.

### Versions and patches

#### `Alpine-WSL`

Version `3.21.3-1` with 1 patch set:
* Update Alpine to 3.23.0 and add Lima required tools.

#### `docker-cli`

Version `29.1.5`. Rebuilt for Windows amd64 platform.

#### `docker-compose`

Version `5.0.1`. Rebuilt for Windows amd64 platform.

#### `gvisor-tap-vsock`

Version bundled with Podman is used

#### `go-wsllinks`

Version `0.0.9`. Rebuilt for Windows amd64 platform with 1 patch set:
* Package as Lima dependcies.

#### `Lima`

Version `2.0.3` with 1 patch set:
* Support WSL2 as a replacement for msys2/cygwin.

#### `Podman`

Version `5.7.1` with 2 patch sets:
* Implement QEMU Podman machine on Windows;
* Change CPU HW baseline to x86_64v2 + AES (also known as v2.5);

#### `Podman Desktop`

Should be installed via official setup mechanism.

#### `QEMU`

Starting from version `0.0.18` of qcw it is possible to use with official windows builds of QEMU (including msys2).
To launch Lima one still will need the patched version of QEMU.

Version `10.2.0` with 6 patch sets:
* revert futimens introduction for 9pfs;
* hw/9pfs: Add 9pfs support for Windows https://lists.gnu.org/archive/html/qemu-devel/2023-02/msg05533.html;
* Compilation fixes accomodating for latest changes withit 9pfs source files;
* WHPX: Add support for device backed memory regions https://lists.gnu.org/archive/html/qemu-devel/2022-07/msg04837.html;
* mingw related fixes https://lists.nongnu.org/archive/html/qemu-devel/2025-12/msg01895.html;
* ftruncate detection fixes https://lists.gnu.org/archive/html/qemu-devel/2026-01/msg01237.html.

#### `sshocker`

Version bundled with Lima is used.

## How to use QEMU

It is packaged the way similar to official builds, one can just follow official installation instructions. Changed from official
buids are considered unstable and discouraged to be used on their own. This is why no additional manual is provided.

## How to use Podman

### Basics

Download installation packages of the release. Install QEMU and Podman using their installers. Then install
`qcw-utils` in the desired directory by opening powershell shell and executing
`iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/arixmkii/qcw/main/qcw-utils.ps1'))`
(each release will have tagged version of this utility as well if
one wants more control over tools version). One will have preconfigured shell launchers under `.\qcw-utils\shells\`
when installation completes. When using `podman-default.bat` one needs to configure machine provider in
`%APPDATA%\containers\containers.conf` setting `provider = "qemu"` or `provider = "wsl"` inside `[machine]` section.

Then run the Podman machine init command as one would do with all other Podman installations. The catch is to give
2 mandatory config overrides

```bat
podman machine init -v ""
```

All other options (except virtfs volume mounts) from QEMU on Linux should work the same way, so, one should be able to
tweak the machine to the needed performance requirements.

File system mounts on Windows are unsupported since Podman QEMU had switched to `virtiofsd` for providing access to host file
system. Virtiofs in general and `virtiofsd` server specifically are currently usupported on Windows. It should be possible to
re-add older implementation with `9p` filesystem back for Windows, but it is not really viable before QEMU adds finalized
`9p` support in their Windows builds.

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

### With `docker-compose`

If one has access to `Docker Desktop` it is possible to use binaries distributed by the software to connect them to
Podman. Alternatively it is possible to download pre-built binaries of the CLI and compose plugin from releases page.

After downloading and unpacking binaries one should make the tools discoverable inside `%PATH%`. To make `docker` 
recognize the plugin it is recommended to put it into a well-known location like `%USERPROFILE%\.docker\cli-plugins`.
This step is not needed if `Docker Desktop` is used as this configures everythign on your behalf.

Using `podman compose`, when `docker-compose` is discoverable:
```bat
podman compose up --wait
```

Using `docker compose` one needs to provide DOCKER_HOST value with named pipe from
`podman machine inspect --format {{.ConnectionInfo.PodmanPipe.Path}}` converted to URL compatible address: 
`\\.\pipe\podman-machine-default` would become `npipe:////./pipe/podman-machine-default`
```bat
set DOCKER_HOST=npipe:////./pipe/podman-machine-default
docker compose up --wait
```

## How to use Lima

### Preparation

Donwload from release page `lima-infra` WSL distribution. If one was previously installed it should be first removed
using command `wsl --unregister lima-infra`. Install the new one by double clicking on the `.wsl` file or using command
`wsl --install --from-file lima-infra.wsl` (if one uses this, then it is important to open default shell with
`wsl -d lima-infra` for setup completion). Don't rename the distribution - currently only predefined name `lima-infra`
having default user `lima` is supported.

### Basics

Download `lima.zip` and extract it to the local machine. Either add `<path-to-extract>\lima\bin` to your PATH environment variable
or run terminal inside `<path-to-extract>\lima\bin` folder.

Then one has to decide on the tooling, which has different level of supported features. To specify tooling one shall set
`_LIMA_WINDOWS_EXTRA_PATH` environment variable to the location of tools

* for WSL2 based tools - `<path-to-extract>\lima\bin\bundle-wsl`
* for Git packaged tools (assuming default installation) - `C:\Program Files\Git\usr\bin`

Only 2 templates - `default` and `experimental/wsl2` has been tested to work. Others are considered unsupported.

#### QEMU machine `default`

Create new instance.

```bat
limactl create template://default
```

Start the instance as normal

```bat
limactl start default
```

Then start the first container with

```bat
limactl shell default nerdctl run -it --rm -p 8080:80 nginx
```

And test it with `curl`

```bat
curl http://localhost:8080
```

#### WSL2 machine `experimental/wsl2`

Create new instance.

```bat
limactl create template://experimental/wsl2
```

Start the instance as normal

```bat
limactl start wsl2
```

Then start the first container with

```bat
limactl shell wsl2 sudo nerdctl run -it --rm -p 8080:80 nginx
```

And test it with `curl`

```bat
curl http://localhost:8080
```

## Known issues QEMU

### 1. Incomplete 9pfs implmenetation

The patch used to enable 9pfs is a work in progress. Some of the functionality is missing or is unstable:
* it is impossible to enumerate content of directories containing Windows symlinks;
* it is impossible to enumerate content of directories containing Windows Unix domain socket records;
* non determenistic access denied could be thrown on file overwrites because of some internal races.

### 2. Limited hardware level support

Currently WHPX acceleration doesn't support instructions beyond v2.5 https://gitlab.com/qemu-project/qemu/-/issues/2782
Containers, which require v3 and more modern hardware will not run at all (it doesn't matter if host is capable or not).

## Known issues Podman

### 1. Sometimes sock files are not cleaned up (if somethign crashes)

There could be leftovers in `%TEMP%\podman`, which prevents `QEMU` or `gvproxy` startup. Solution is to shutdown machine
and then clean up this location manually before starting again.

### 2. File system mounts are unsupported

There is no way to use file system mounts in Podman with QEMU on Windows hosts.

## Known issues Lima

### 1. AF_UNIX port forwarding from VM doesn't work

Additional work is required to bring AF_UNIX port forwarding (same applied to Unix socket to named pipe forwarding)

### 2. Key pairs created with Windows tools will lack Unix permissions and will be rejected by WSL2 tools

To use such key pairs one would need to manually adjust their persmissions from `wsl` shell of `lima-infra` distribution.
