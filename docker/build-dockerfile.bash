#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")/.."

if [[ "$#" -eq 0 ]]; then
    echo >&2 "usage: $0 NAME [ARG...]"
    exit 1
fi

name="$1"
shift

docker() {
    if [[ "${OSTYPE:-}" != darwin* ]] && [[ "${EUID}" != 0 ]]; then
        sudo -E docker "$@"
    else
        docker "$@"
    fi
}

docker build . -f "./Dockerfile.${name}" -t "pass-ln-${name}" "$@"
