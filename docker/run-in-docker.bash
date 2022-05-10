#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")/.."

if [[ "$#" -eq 0 ]]; then
    echo >&2 "usage: $0 IMAGE [CMD...]"
    exit 1
fi

docker() {
    if [[ "${OSTYPE:-}" != darwin* ]] && [[ "${EUID}" != 0 ]]; then
        sudo -E docker "$@"
    else
        docker "$@"
    fi
}

args=(bash)
if [[ "$#" -gt 1 ]]; then
    args=("${@:2}")
fi

opts=(-i --rm -v "${PWD}:/src" -w /src --entrypoint=/src/docker/entrypoint.bash)
if [[ -t 0 ]]; then
    opts+=("-t")
fi

docker run "${opts[@]}" "$1" "${args[@]}"
