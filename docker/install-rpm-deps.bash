#!/usr/bin/env bash

set -euxo pipefail

sed -i 's/^tsflags=nodocs/#&/' /etc/dnf/dnf.conf

dnf install -y bash-completion git make man-db rpm-build

dnf clean all

rm "$0"
