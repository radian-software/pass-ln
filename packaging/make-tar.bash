#!/usr/bin/env bash

set -euxo pipefail

rm -rf tmp

mkdir -p "tmp/pass-ln-${VERSION}/lib/password-store/extensions"
cp ../pass-ln.bash "tmp/pass-ln-${VERSION}/lib/password-store/extensions/ln.bash"
sed -E "s/^VERSION=.+/VERSION=${VERSION}/" \
    "tmp/pass-ln-${VERSION}/lib/password-store/extensions/ln.bash" > \
    "tmp/pass-ln-${VERSION}/lib/password-store/extensions/ln.bash.tmp"
mv "tmp/pass-ln-${VERSION}/lib/password-store/extensions/ln.bash.tmp" \
   "tmp/pass-ln-${VERSION}/lib/password-store/extensions/ln.bash"
chmod +x "tmp/pass-ln-${VERSION}/lib/password-store/extensions/ln.bash"

mkdir -p "tmp/pass-ln-${VERSION}/etc/bash_completion.d"
cp ../pass-ln.bash.completion "tmp/pass-ln-${VERSION}/etc/bash_completion.d/pass-ln"

mkdir -p "tmp/pass-ln-${VERSION}/share/doc/pass-ln"
cp ../CHANGELOG.md ../LICENSE.md "tmp/pass-ln-${VERSION}/share/doc/pass-ln/"

mkdir -p "tmp/pass-ln-${VERSION}/share/man/man1"
cp ../pass-ln.1 "tmp/pass-ln-${VERSION}/share/man/man1/"

cd tmp
mkdir -p "../out/${VERSION}"
tar -cvf "../out/${VERSION}/pass-ln-${VERSION}.tar.gz" "pass-ln-${VERSION}"
