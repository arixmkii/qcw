#!/bin/bash

requiredQemuDlls=("SDL2.dll" "libatk-1.0-0.dll" "libbrotlicommon.dll" "libbrotlidec.dll" "libbrotlienc.dll" "libbz2-1.dll" "libcairo-2.dll" "libcairo-gobject-2.dll" "libdatrie-1.dll" "libepoxy-0.dll" "libexpat-1.dll" "libffi-8.dll" "libfontconfig-1.dll" "libfreetype-6.dll" "libfribidi-0.dll" "libgcc_s_seh-1.dll" "libgdk-3-0.dll" "libgdk_pixbuf-2.0-0.dll" "libgio-2.0-0.dll" "libglib-2.0-0.dll" "libgmodule-2.0-0.dll" "libgobject-2.0-0.dll" "libgraphite2.dll" "libgtk-3-0.dll" "libharfbuzz-0.dll" "libiconv-2.dll" "libintl-8.dll" "libjpeg-8.dll" "liblzo2-2.dll" "libncursesw6.dll" "libpango-1.0-0.dll" "libpangocairo-1.0-0.dll" "libpangoft2-1.0-0.dll" "libpangowin32-1.0-0.dll" "libpcre2-8-0.dll" "libpixman-1-0.dll" "libpng16-16.dll" "libssp-0.dll" "libstdc++-6.dll" "libthai-0.dll" "libwinpthread-1.dll" "libzstd.dll" "zlib1.dll" "libslirp-0.dll" "libcrypto-1_1-x64.dll" "libcurl-4.dll" "libgmp-10.dll" "libgnutls-30.dll" "libhogweed-6.dll" "libidn2-0.dll" "libnettle-8.dll" "libp11-kit-0.dll" "libpsl-5.dll" "librtmp-1.dll" "libssh.dll" "libssh2-1.dll" "libtasn1-6.dll" "libunistring-2.dll" "SDL2_image.dll" "libLerc.dll" "libdeflate.dll" "libhwy.dll" "libjxl.dll" "liblcms2-2.dll" "liblzma.dll" "libtiff-5.dll" "libwebp-7.dll")

for dll in ${requiredQemuDlls[*]}; do
    cp $(which $dll) qcw/qemu/$dll
done
