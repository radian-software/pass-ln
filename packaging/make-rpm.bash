#!/usr/bin/env bash

set -euxo pipefail

rm -rf tmp

mkdir -p tmp/SPECS
eval "$(printf 'cat <<EOF\n%s\nEOF\n' "$(< ./pass-ln.spec.tmpl)")" > "tmp/SPECS/pass-ln.spec"

mkdir -p tmp/SOURCES
cp "out/${VERSION}/pass-ln-${VERSION}.tar.gz" tmp/SOURCES/

rpmbuild -ba --define "_topdir ${PWD}/tmp" tmp/SPECS/pass-ln.spec
cp tmp/RPMS/noarch/*.rpm "out/${VERSION}/pass-ln-${VERSION}.rpm"
