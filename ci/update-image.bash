#!/usr/bin/env bash

set -euo pipefail

: "${GITHUB_TOKEN}"

ts="$(date +%s)"

if [[ "$#" -eq 0 || "$1" != "-n" ]]; then
    docker build . -t pass-ln
    ./docker/run-in-docker.bash pass-ln shellspec
fi

image="ghcr.io/raxod502/pass-ln-ci:${ts}"

echo "${GITHUB_TOKEN}" | docker login ghcr.io -u raxod502 --password-stdin

docker tag pass-ln "${image}"
docker push "${image}"

echo "${image}" > ./ci/current-image
