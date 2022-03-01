#!/usr/bin/env bash

set -euxo pipefail

rm -rf tmp

mkdir -p tmp/usr/lib/password-store/extensions
cp ../pass-ln.bash tmp/usr/lib/password-store/extensions/ln.bash

mkdir -p tmp/usr/share/doc/pass-ln
cp ../CHANGELOG.md tmp/usr/share/doc/pass-ln/
gzip tmp/usr/share/doc/pass-extension-ln/CHANGELOG.md

mkdir -p tmp/DEBIAN
tee tmp/DEBIAN/control <<EOF >/dev/null
Package: pass-extension-ln
Version: ${VERSION}
Section: admin
Priority: optional
Architecture: all
Maintainer: Radon Rosborough <radon.neon@gmail.com>
Description: Pass extension for creating symbolic links
Depends: pass
EOF

mkdir -p "out/${VERSION}"
fakeroot dpkg-deb --build tmp "out/${VERSION}/pass-extension-ln-${VERSION}.deb"
