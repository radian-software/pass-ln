#!/usr/bin/env bash

set -euxo pipefail

rm -rf tmp
mkdir -p tmp
tar -xf "out/${VERSION}/pass-ln-homebrew-${VERSION}.tar.gz" --strip-components=1 -C tmp

sed -E "s|url .+|url \"file://${PWD}/out/${VERSION}/pass-ln-${VERSION}.tar.gz\"|" tmp/pass-ln.rb > tmp/pass-ln.rb.tmp
mv tmp/pass-ln.rb.tmp tmp/pass-ln.rb

brew reinstall --formula ./tmp/pass-ln.rb
