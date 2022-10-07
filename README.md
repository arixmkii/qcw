# qcw
Qemu Containers for Windows

## About the project

This project contains patches and build scripts to create binary distributions of the software for running containers
on Windows using Qemu virtualization. It started in the scope of the discussion of the
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

#### `gvisor-tap-vsock`

Version `0.5.0-dev` is used.

#### `Podman`

Version `4.3.0-dev` with a patch to enable using QEMU machine on Windows hosts. This is continuous work trying
to upstream the changes, where possible. At the end this should come down to a single patch on top on a stable tag.
Supposed to be a long living patchwork, because needs full support for some features on QEMU side (see QEMU specific
patches).

#### `Podman Desktop`

Latest version (or stable later than v0.0.6) is a requirement. Should be installed via official setup mechanism.

#### `QEMU`

Version `7.2.0-dev` with 1 patch set from QEMU mailing list:
* one set to enable unix domain sockets backed `-netdev`.

Both patches have numerous reviews already and probably will move forward in the next release window.

#### `XZ Utils`

Version `5.2.7` w/o any changes.

## How to use

### Basics

Donwload the archive and unpack it into your Windows machine to some location (`C:\qcw` for example).
Then there are 2 preconfigured shell starters in `.\shells\` directory - one for QEMU and one should be backward
compatible with default Podman for Windows behavior using WSL2 machines.

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
"Podman Desktop"
```

## Missing features

* `9pfs` support - there is a patch set in QEMU devel mailing list, but it needs to be rebased and updated for the
latest code changes. There are hopes that a new revision will appear during next release window.
Last known update https://lists.gnu.org/archive/html/qemu-devel/2022-04/msg00983.html

## Known issues

### 1. Name collisions between QEMU and WSL2

Machines are fully isolated, but the ssh public/private key naming scheme is not, so, if machine names are the same,
then only one of them would have valid keys. Workaround is not to use default names for machines if user plans to use
both QEMU and WSL.

### 2. Machine keys are not added to `known_hosts` by default

They could be added manually or with some tooling.
Using `ssh-keyscan`:
First check on which port machine is expecting ssh with
```bat
podman system connection list
```
Then (with machine running) run (where 65103 is the port discovered)
```bat
ssh-keyscan -p 65103 127.0.0.1 >> %USERPROFILE%\.ssh\known_hosts
```
And then manually change `[127.0.0.1]` to `localhost` in `%USERPROFILE%\.ssh\known_hosts` file. This is needed because
`ssh-keyscan` is resolving `localhost` with IPv6, but `gvisor-tap-proxy` only works with IPv4 for now.

### 3. Sometimes sock files are not cleaned up (if somethign crashes)

There could be lefovers in `%TEMP%\podman`, which prevents `QEMU` or `gvproxy` startup. Solution is to shutdown machine
and then cleanup this location manually before starting again.
