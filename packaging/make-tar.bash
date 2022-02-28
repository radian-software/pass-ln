#!/usr/bin/env bash

set -euxo pipefail

rm -rf tmp

mkdir -p "tmp/pass-ln-${VERSION}/lib/password-store/extensions"
cp ../pass-ln.bash "tmp/pass-ln-${VERSION}/lib/password-store/extensions/ln.bash"

cd tmp
mkdir -p "../out/${VERSION}"
tar -cvf "../out/${VERSION}/pass-ln-${VERSION}.tar.gz" "pass-ln-${VERSION}"
