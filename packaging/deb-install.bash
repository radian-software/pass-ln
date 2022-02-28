#!/usr/bin/env bash

set -euxo pipefail

./make-deb.bash
sudo apt reinstall "./out/${VERSION}/pass-extension-ln-${VERSION}.deb"
