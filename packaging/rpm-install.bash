#!/usr/bin/env bash

set -euxo pipefail

sudo dnf reinstall "./out/${VERSION}/pass-ln-${VERSION}.rpm"
