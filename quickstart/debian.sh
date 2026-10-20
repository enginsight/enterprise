#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

if ! type "docker" > /dev/null; then
  sudo apt update
	sudo apt install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
	curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
	sudo apt update
	sudo apt install -y docker-ce
fi

if ! type "docker-compose" > /dev/null; then
  sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
fi

if ! type "curl" > /dev/null; then
  sudo apt update
	sudo apt install -y curl
fi

mkdir -p enterprise && cd enterprise
curl -fsSL https://get.enginsight.com/on-premises/on-premises.tar.gz | tar -xz --strip-components=1

#clear
echo $DOCKER_PASSWORD | docker login --username $DOCKER_USERNAME --password-stdin

#clear
chmod +x ./setup.sh && (cd .; source ./setup.sh docker)
