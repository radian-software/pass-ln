#!/usr/bin/env bash

set -euxo pipefail

sudo yum install "./out/${VERSION}/pass-ln-${VERSION}.rpm"
