sudo apt update
sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install docker.io docker-compose

sudo groupadd docker || true
sudo usermod -aG docker ${USER}

bash

# setup hawkbit
git clone https://github.com/eclipse/hawkbit.git
pushd hawkbit

git apply ../compose-fixup.patch

pushd hawkbit-runtime/docker
docker-compose up -d

popd
popd

# setup chunkstore
pushd chunkstore
docker-compose up -d
