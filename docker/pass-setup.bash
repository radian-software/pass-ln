#!/usr/bin/env bash

set -euo pipefail

git config --global user.name Testing
git config --global user.email testing@example.com

cat <<"EOF" > /tmp/batch.gpg
Key-Type: RSA
Key-Length: 2048
Subkey-Type: RSA
Subkey-Length: 2048
Name-Real: Testing
Name-Email: testing@example.com
Expire-Date: 1d
%no-protection
%commit
EOF

gpg --batch --gen-key /tmp/batch.gpg
pass init Testing
pass git init
pass generate example.com/testing@example.com
