### Highlights
<<RELEASE_HIGHLIGHTS>>

#### Included in this release
* Bundles `<<BUNDLES_VERSION>>`
* Docker CLI `<<DOCKER_VERSION>>`
* Docker Compose `<<DOCKER_COMPOSE_VERSION>>`
* go-wsllinks `<<GOWSLLINKS_VERSION>>`
* Lima `<<LIMA_VERSION>>` with patches to enable WSL userland tools support
* lima-infra Alpine WSL image `<<ALPINE_VERSION>>` based on AlpineWSL project `<<ALPINEWSL_VERSION>>`
* Podman `<<PODMAN_VERSION>>` with patches to enable QEMU support on Windows
* QEMU `<<QEMU_VERSION>>` (this one includes 9pfs on Windows hosts patches, if this functionality is not needed, then consider using official installer)

#### IMPORTANT! Security considerations for QEMU builds

These builds include 9pfs support added based on patches, which were not included in the upstream because of
security issues - DoS possibility from untrusted guests. See https://gitlab.com/qemu-project/qemu/-/work_items/974
for details.

These QEMU builds are not recommended as a general purpose replacement for official and third party QEMU builds.

#### Recommendations on Docker releases

These builds are of the most value if one can't use binaries provided as part of Docker Desktop for Windows
offering. They should have no functional differences from their official conuterparts, but they are not
tested for the perfect match between CLI and Compose versions. It is advised to use official builds where
possible for production purposes.

#### Recommendations on Lima releases

Lima project now publishes the Widnows artifacts as part of their release procedure. While this build of
Lima should be functionally identical to the official ones, it is only recommended if the user wants to
try alternative WSL based containerised utility set to run Lima (instead of `Git for Windows` dependency).

#### Recommendations on Podman releases

This build of Podman is only recommended for users, who need QEMU support for Podman machine. While it
should contain no functional differences from official builds, the binaries are not signed and doesn't
meet all the production requirements. It is advised to use official releases from Podman team for
production purposes.

#### Deprecation notice

MINGW64 Mys2 Environment is being depricated https://www.msys2.org/news/#2026-03-15-deprecating-the-mingw64-environment
This effectively deprecated QEMU builds for this environemnt, they will continue to be available until
they become broken, but users are encouraged to use other provided flavours - URCT64 or CLANG64.

#### How to install
1. Download and install QEMU (from this release or official one version 7.2.0 or newer)
2. Download and install Podman from this release (it might be a good idea to uninstall one first if you had it before)
3. Choose a location where you want utilities to reside and open Powershell terminal there, then execute 
```pwsh
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
