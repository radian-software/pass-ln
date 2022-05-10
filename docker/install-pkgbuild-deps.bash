#!/usr/bin/env bash

set -euxo pipefail

sed -i 's/^NoExtract.*/#&/' /etc/pacman.conf

pacman -Sy --noconfirm bash-completion git man-db

rm -rf /var/cache/pacman/pkg/*
rm "$0"
