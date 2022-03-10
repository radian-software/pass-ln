#!/usr/bin/env bash

set -euo pipefail

image="$(< ./ci/current-image)"

echo "${GITHUB_TOKEN}" | docker login ghcr.io -u raxod502 --password-stdin

./docker/run-in-docker.bash "${image}" shellspec
