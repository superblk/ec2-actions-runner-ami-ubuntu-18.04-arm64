#!/bin/bash

set -euxo pipefail

apt-get update
apt-get install -y apt-transport-https ca-certificates curl gnupg
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo 'deb [arch=arm64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu bionic stable' > /etc/apt/sources.list.d/docker.list

apt-get update
apt-get install -y jq at git docker-ce docker-ce-cli containerd.io openssl libssl-dev pkg-config
usermod -aG docker ubuntu
systemctl enable docker.service
systemctl enable containerd.service

cd /home/ubuntu
mkdir actions-runner && cd actions-runner
# See https://github.com/actions/runner/releases
curl -fsSLo actions-runner.tar.gz https://github.com/actions/runner/releases/download/v2.284.0/actions-runner-linux-arm64-2.284.0.tar.gz
echo "a7a4e31d93d5852710dbacbb5f024be581c337c1be92ba2c729bb81e756bd49b actions-runner.tar.gz" | sha256sum -c
tar xzf actions-runner.tar.gz
rm -f actions-runner.tar.gz
./bin/installdependencies.sh

chown -R ubuntu:ubuntu /home/ubuntu/actions-runner
