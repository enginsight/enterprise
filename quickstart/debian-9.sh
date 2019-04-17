if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

DOCKER_USERNAME=''
DOCKER_PASSWORD=''
MONGODB_URI=''
REDIS_URI=''
APP_URL=''
API_URL=''
LICENSE=''
COOKIE_DOMAIN=''

for i in "$@"
do
case $i in
DOCKER_USERNAME=*)
    DOCKER_USERNAME="${i##*=}"
    shift # past argument=value
    ;;
DOCKER_PASSWORD=*)
    DOCKER_PASSWORD="${i##*=}"
    shift # past argument=value
    ;;
MONGODB_URI=*)
    MONGODB_URI="${i##*=}"
    shift # past argument=value
    ;;
REDIS_URI=*)
    REDIS_URI="${i##*=}"
    shift # past argument=value
    ;;
APP_URL=*)
    APP_URL="${i##*=}"
    shift # past argument=value
    ;;
API_URL=*)
    API_URL="${i##*=}"
    shift # past argument=value
    ;;
LICENSE=*)
    LICENSE="${i##*=}"
    shift # past argument=value
    ;;
COOKIE_DOMAIN=*)
    COOKIE_DOMAIN="${i##*=}"
    shift # past argument=value
    ;;
esac
done

ip4=$(hostname -I | cut -f1 -d '')

if [ ! "$API_URL" ]; then
API_URL=http://$ip4:8080
fi

if [ ! "$APP_URL" ]; then
APP_URL=http://$ip4
COOKIE_DOMAIN=$ip4
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
chmod +x ./setup.sh
echo $(printf '%q' "$MONGODB_URI")
cat ./setup.sh | bash -s \
  MONGODB_URI="$(printf '%q' "$MONGODB_URI")" \
  REDIS_URI="$(printf '%q' "$REDIS_URI")" \
  APP_URL="$(printf '%q' "$APP_URL")" \
  API_URL="$(printf '%q' "$API_URL")" \
  COOKIE_DOMAIN="$(printf '%q' "$COOKIE_DOMAIN")" \
  LICENSE="$(printf '%q' "$LICENSE")"
