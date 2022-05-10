#!/usr/bin/env bash

set -euxo pipefail

export DEBIAN_FRONTEND=noninteractive

(yes || true) | unminimize
apt-get install -y build-essential curl file git make man-db procps sudo wget

rm -rf /var/lib/apt/lists/*
rm "$0"
