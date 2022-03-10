#!/usr/bin/env bash

set -euxo pipefail

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y curl git jq make pass sudo wget

rm -rf /var/lib/apt/lists/*
rm "$0"
