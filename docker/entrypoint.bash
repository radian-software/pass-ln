#!/usr/bin/env bash

set -euo pipefail

runuser=()
if command -v sudo &>/dev/null; then
    groupadd sudo -g 27 2>/dev/null ||:
    runuser+=(runuser -u docker --)
fi

groupadd -g "$(stat -c %g "$PWD")" -o -p '!' -r docker
useradd -u "$(stat -c %u "$PWD")" -g "$(stat -c %g "$PWD")" -o -p '!' -m -N -l -s /usr/bin/bash -G sudo docker

mkdir -p /etc/sudoers.d
tee > /etc/sudoers.d/docker <<"EOF"
%sudo	ALL=(ALL:ALL) NOPASSWD: ALL
EOF

"${runuser[@]}" touch /home/docker/.sudo_as_admin_successful

exec "${runuser[@]}" "$@"
