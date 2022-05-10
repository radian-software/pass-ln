#!/usr/bin/env bash

set -euxo pipefail

groupadd -g 500 -p '!' -r linuxbrew
useradd -u 500 -g 500 -p '!' -m -l -s /usr/bin/bash -G sudo linuxbrew

mkdir -p /etc/sudoers.d
tee /etc/sudoers.d/linuxbrew >/dev/null <<"EOF"
%sudo	ALL=(ALL:ALL) NOPASSWD: ALL
EOF

# https://brew.sh/
set +x
script="$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
runuser -u linuxbrew -- bash -c "${script}"

runuser -u linuxbrew -- /home/linuxbrew/.linuxbrew/bin/brew install bash-completion

# Workaround bash-completion and util-linux somehow conflicting?? T_T
runuser -u linuxbrew -- /home/linuxbrew/.linuxbrew/bin/brew unlink bash-completion
runuser -u linuxbrew -- /home/linuxbrew/.linuxbrew/bin/brew install util-linux
runuser -u linuxbrew -- /home/linuxbrew/.linuxbrew/bin/brew link bash-completion --overwrite

tee /etc/profile.d/linuxbrew.sh >/dev/null <<"EOF"
echo >&2 "Fixing Homebrew permissions..."
sudo chown -R "$(whoami)" /home/linuxbrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

if [[ -r "/home/linuxbrew/.linuxbrew/etc/profile.d/bash_completion.sh" ]]; then
    echo >&2 "Enabling bash-completion..."
    . "/home/linuxbrew/.linuxbrew/etc/profile.d/bash_completion.sh"
fi
EOF
