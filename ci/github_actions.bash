#!/usr/bin/env bash

set -euo pipefail

image="$(< ./ci/current_image)"

./docker/run-in-docker.bash "${image}" shellspec
