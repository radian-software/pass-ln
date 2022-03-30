#!/usr/bin/env bash

set -euxo pipefail

rm -rf tmp

mkdir -p tmp/tar
tar -xf "out/${VERSION}/pass-ln-${VERSION}.tar.gz" --strip-components=1 -C tmp/tar

mkdir -p tmp/pkg/usr/lib/password-store/extensions
cp tmp/tar/lib/password-store/extensions/ln.bash \
   tmp/pkg/usr/lib/password-store/extensions/

mkdir -p tmp/pkg/etc/bash_completion.d
cp tmp/tar/etc/bash_completion.d/pass-ln \
   tmp/pkg/etc/bash_completion.d/

mkdir -p tmp/pkg/usr/share/doc/pass-extension-ln
cp tmp/tar/share/doc/pass-ln/* tmp/pkg/usr/share/doc/pass-extension-ln/
gzip tmp/pkg/usr/share/doc/pass-extension-ln/*

mkdir -p tmp/pkg/usr/share/man/man1
cp tmp/tar/share/man/man1/pass-ln.1 tmp/pkg/usr/share/man/man1/
gzip tmp/pkg/usr/share/man/man1/pass-ln.1

mkdir -p tmp/pkg/DEBIAN
tee tmp/pkg/DEBIAN/control <<EOF >/dev/null
Package: pass-extension-ln
Version: ${VERSION}
Section: admin
Priority: optional
Architecture: all
Maintainer: Radon Rosborough <radon.neon@gmail.com>
Description: Pass extension for creating symbolic links
Depends: pass, coreutils
EOF

mkdir -p "out/${VERSION}"
fakeroot dpkg-deb --build tmp/pkg "out/${VERSION}/pass-extension-ln-${VERSION}.deb"
