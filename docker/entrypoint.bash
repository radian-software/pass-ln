#!/usr/bin/env bash

set -euo pipefail

groupadd -g "$(stat -c %g "$PWD")" -o -p '!' -r docker
useradd -u "$(stat -c %u "$PWD")" -g "$(stat -c %g "$PWD")" -o -p '!' -m -N -l -s /usr/bin/bash -G sudo docker

tee > /etc/sudoers.d/docker <<"EOF"
%sudo	ALL=(ALL:ALL) NOPASSWD: ALL
EOF

runuser -u docker -- touch /home/docker/.sudo_as_admin_successful

exec runuser -u docker -- "$@"
