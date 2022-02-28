#!/usr/bin/env bash

set -euxo pipefail

sudo apt reinstall "./out/${VERSION}/pass-extension-ln-${VERSION}.deb"
