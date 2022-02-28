#!/usr/bin/env bash

set -euxo pipefail

rm -rf tmp
mkdir -p "tmp/pass-ln-homebrew-${VERSION}"
eval "$(printf 'cat <<EOF\n%s\nEOF\n' "$(< ./pass-ln.rb.tmpl)")" > "tmp/pass-ln-homebrew-${VERSION}/pass-ln.rb"

cd tmp
mkdir -p "../out/${VERSION}"
tar -cvf "../out/${VERSION}/pass-ln-homebrew-${VERSION}.tar.gz" "pass-ln-homebrew-${VERSION}"
