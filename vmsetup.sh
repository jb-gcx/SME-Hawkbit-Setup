#!/bin/bash

set -eu

pushd "$(dirname $0)"
setup_dir="$(pwd)"
popd

target="$1"

sudo apt update
sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install docker.io docker-compose

sudo groupadd docker || true
sudo usermod -aG docker ${USER}

bash

pushd "$target"

# setup hawkbit
git clone -n https://github.com/eclipse/hawkbit.git
pushd hawkbit

git checkout 2574581b2c0b1e19cc8d127409229d306616049c
git apply "$setup_dir/compose-fixup.patch"

pushd hawkbit-runtime/docker
docker-compose up -d

popd
popd

# setup chunkstore
cp -r "$setup_dir/chunkstore" "$target/chunkstore"
pushd "$target/chunkstore"
docker-compose up -d
popd
