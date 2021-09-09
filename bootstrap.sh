#!/bin/bash

set -euxo pipefail

apt-get update
apt-get install -y apt-transport-https ca-certificates curl gnupg
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo 'deb [arch=arm64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu bionic stable' > /etc/apt/sources.list.d/docker.list

apt-get update
apt-get install -y git docker-ce docker-ce-cli containerd.io openssl libssl-dev pkg-config at
usermod -aG docker ubuntu
systemctl enable docker.service
systemctl enable containerd.service

cd /home/ubuntu
mkdir actions-runner && cd actions-runner
# See https://github.com/actions/runner/releases
curl -fsSLo actions-runner.tar.gz https://github.com/actions/runner/releases/download/v2.280.3/actions-runner-linux-arm64-2.280.3.tar.gz
echo "6b838e76a3ee3ead883e1b9b395e2044af473ccf78ed3ae86e94c8801a1b620b actions-runner.tar.gz" | sha256sum -c
tar xzf actions-runner.tar.gz
rm -f actions-runner.tar.gz
./bin/installdependencies.sh

chown -R ubuntu:ubuntu /home/ubuntu/actions-runner
