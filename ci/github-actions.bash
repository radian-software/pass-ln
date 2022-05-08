#!/usr/bin/env bash

set -euo pipefail

image="$(< ./ci/current-image)"

echo "${GITHUB_TOKEN}" | docker login ghcr.io -u radian-software --password-stdin

./docker/run-in-docker.bash "${image}" shellspec
