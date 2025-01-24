### Highlights
<<RELEASE_HIGHLIGHTS>>

#### Included in this release
* Docker CLI `<<DOCKER_VERSION>>`
* Docker Compose `<<DOCKER_COMPOSE_VERSION>>`
* go-wsllinks `<<GOWSLLINKS_VERSION>>`
* Lima `<<LIMA_VERSION>>` with patches to enable QEMU support on Windows
* lima-infra Alpine WSL image `<<ALPINE_VERSION>>` based on AlpineWSL project `<<ALPINEWSL_VERSION>>`
* Podman `<<PODMAN_VERSION>>` with patches to enable QEMU support on Windows
* QEMU `<<QEMU_VERSION>>` (this one includes 9pfs on Windows hosts patches and UEFI pflash fixes, if this functionality is not needed, then consider using official installer, this is required to run Lima)

#### How to install
1. Download and install QEMU (from this release or official one version 7.2.0 or newer)
2. Download and install Podman from this release (it might be a good idea to uninstall one first if you had it before)
3. Choose a location where you want utilities to reside and open Powershell terminal there, then execute 
```powershell
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/arixmkii/qcw/<<TAG_NAME>>/qcw-utils.ps1'))
```
4. Follow the instructions in README.

#### SHA checksums
**SHA256**
```
<<SHA256>>
```

**SHA512**
```
<<SHA512>>
```

#### Build log
Build log is available for 90 days at <<BUILD_LOG_URL>>
