#!/usr/bin/env bash

set -euxo pipefail

dnf install -y git make man-db rpmbuild

dnf clean all

rm "$0"
