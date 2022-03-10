#!/usr/bin/env bash

set -euxo pipefail

mkdir /tmp/work
cd /tmp/work

ver="$(curl -fsSL https://api.github.com/repos/shellspec/shellspec/releases/latest | jq -r .tag_name)"
wget "https://github.com/shellspec/shellspec/archive/refs/tags/${ver}.tar.gz" -O shellspec.tar.gz
mkdir shellspec
tar -xf shellspec.tar.gz --strip-components=1 -C shellspec
make install -C shellspec

rm -rf /tmp/work
rm "$0"
