#!/usr/bin/env bash

set -euxo pipefail

rm -rf tmp
mkdir -p tmp
tar -xf "out/${VERSION}/pass-ln-pkgbuild-${VERSION}.tar.gz" --strip-components=1 -C tmp
cp "out/${VERSION}/pass-ln-${VERSION}.tar.gz" tmp/

cd tmp
sed -E "s|source=.+|source=('pass-ln-${VERSION}.tar.gz')|" PKGBUILD > PKGBUILD.tmp
mv PKGBUILD.tmp PKGBUILD

makepkg -si
