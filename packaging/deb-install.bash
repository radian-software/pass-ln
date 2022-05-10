#!/usr/bin/env bash

set -euxo pipefail

if [[ -z "$(ls -A /var/lib/apt/lists)" ]]; then
    sudo apt update
fi

sudo apt reinstall "./out/${VERSION}/pass-extension-ln-${VERSION}.deb"
