#!/bin/bash

set -euxo pipefail

apt-get update
apt-get install -y apt-transport-https ca-certificates curl gnupg
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo 'deb [arch=arm64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu bionic stable' > /etc/apt/sources.list.d/docker.list

apt-get update
apt-get install -y git docker-ce docker-ce-cli containerd.io openssl libssl-dev pkg-config
usermod -aG docker ubuntu
systemctl enable docker.service
systemctl enable containerd.service

cd /home/ubuntu
mkdir actions-runner && cd actions-runner
# See https://github.com/actions/runner/releases
curl -fsSLo actions-runner.tar.gz https://github.com/actions/runner/releases/download/v2.278.0/actions-runner-linux-arm64-2.278.0.tar.gz
echo "69daadcbc7a9d50437f005cb6d74870dcc645a9c3a69c14d5235993bbab46f50 actions-runner.tar.gz" | sha256sum -c
tar xzf actions-runner.tar.gz
rm -f actions-runner.tar.gz
./bin/installdependencies.sh

chown -R ubuntu:ubuntu /home/ubuntu/actions-runner
