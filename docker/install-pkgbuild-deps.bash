#!/usr/bin/env bash

set -euxo pipefail

pacman -Sy --noconfirm git

rm -rf /var/cache/pacman/pkg/*
rm "$0"
