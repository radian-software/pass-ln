#!/usr/bin/env bash

set -euxo pipefail

rm -rf tmp
mkdir -p "tmp/pass-ln-pkgbuild-${VERSION}"
eval "$(printf 'cat <<EOF\n%s\nEOF\n' "$(< ./PKGBUILD.tmpl)")" > "tmp/pass-ln-pkgbuild-${VERSION}/PKGBUILD"

cd tmp
mkdir -p "../out/${VERSION}"
tar -cvf "../out/${VERSION}/pass-ln-pkgbuild-${VERSION}.tar.gz" "pass-ln-pkgbuild-${VERSION}"
