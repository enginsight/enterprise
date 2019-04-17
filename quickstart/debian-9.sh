if ! [ -x "$(command -v docker)" ]; then
  	sudo apt update
	sudo apt install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
	curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
	sudo apt update
	sudo apt install -y docker-ce
fi

if ! [ -x "$(command -v docker-compose)" ]; then
  	sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
fi

git clone https://github.com/enginsight/enterprise
cd enterprise

clear
docker login

clear
chmod +x ./setup.sh && ./setup.sh
