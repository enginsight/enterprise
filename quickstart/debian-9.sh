if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

ip4=$(hostname -I | cut -f1 -d ' ')

if [ ! "$API_URL" ]; then
export API_URL='http://$ip4:8080'
fi

if [ ! "$APP_URL" ]; then
export APP_URL='http://$ip4'
export COOKIE_DOMAIN=$ip4
fi

if [ ! "$MONGODB_URI" ]; then
  echo "We need a mongo uri"
  exit 1
fi

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

#clear
echo $DOCKER_PASSWORD | docker login --username $DOCKER_USERNAME --password-stdin

#clear
chmod +x ./setup.sh && (cd .; ./setup.sh)
