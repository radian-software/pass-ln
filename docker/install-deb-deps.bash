#!/usr/bin/env bash

set -euxo pipefail

export DEBIAN_FRONTEND=noninteractive

(yes || true) | unminimize
apt-get install -y bash-completion build-essential git man-db sudo

rm -rf /var/lib/apt/lists/*
rm "$0"
