#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

if ! [ -x "$(command -v docker)" ]; then
  sudo apt update > /dev/null
	sudo apt install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common > /dev/null
	curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add - > /dev/null
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /dev/null
	sudo apt update > /dev/null
	sudo apt install -y docker-ce > /dev/null
fi

if ! [ -x "$(command -v docker-compose)" ]; then
  sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose > /dev/null
	sudo chmod +x /usr/local/bin/docker-compose > /dev/null
fi

if ! [ -x "$(command -v git)" ]; then
  sudo apt update > /dev/null
	sudo apt install -y git > /dev/null
fi

git clone https://github.com/enginsight/enterprise
cd enterprise

#clear
echo $DOCKER_PASSWORD | docker login --username $DOCKER_USERNAME --password-stdin > /dev/null

#clear
chmod +x ./setup.sh && (cd .; source ./setup.sh docker)
