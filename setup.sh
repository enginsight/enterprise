#!/bin/bash

echo ""
echo "    █      Enginsight Enterprise Setup v1.0"
echo "  █ █   █  "
echo "  █ █ █ █  Enginsight GmbH"
echo "  █ █ █ █  Hans-Knöll-Straße 6, 07745 Jena"
echo "  █   █ █  Geschäftsführer: Mario Jandeck, Eric Range"
echo "      █    "
echo ""

DEFAULT_APP_URL=http://$(hostname -I | cut -f1 -d ' ')
DEFAULT_API_URL=http://$(hostname -I | cut -f1 -d ' '):8080
DEFAULT_MONGODB_URI=mongodb://mongodb:27017/enginsight?replicaSet=rs0
DEFAULT_REDIS_URI=redis://redis:6379

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

if ! type "docker" > /dev/null; then
  echo 'Error: docker is not installed.' >&2
  exit 1
fi

if ! type "docker-compose" > /dev/null; then
  echo 'Error: docker-compose is not installed.' >&2
  exit 1
fi

if [[ $1 == "docker" ]]; then
  MONGODB_URI=$DEFAULT_MONGODB_URI
  REDIS_URI=$DEFAULT_REDIS_URI
  APP_URL=$DEFAULT_APP_URL
  API_URL=$DEFAULT_API_URL
fi

if [ ! "$MONGODB_URI" ]; then
read -p 'Enter mongodb uri (default: mongodb://mongodb:27017/enginsight?replicaSet=rs0): ' MONGODB_URI && MONGODB_URI=${MONGODB_URI:-mongodb://mongodb:27017/enginsight?replicaSet=rs0}
fi

if [[ ! $MONGODB_URI == *"replicaSet"* ]]; then
  exit 1
fi

if [ ! "$MONGODB_URI" ]; then
read -p 'Enter your licence: ' LICENCE
if [ -z "$LICENCE" ]; then
  echo "We need a licence."
  exit 1
fi
fi

if [ ! "$REDIS_URI" ]; then
read -p 'Enter redis uri (default: redis://redis:6379) : '  REDIS_URI && REDIS_URI=${REDIS_URI:-redis://redis:6379}
fi

if [ ! "$APP_URL" ]; then
read -p "Enter app url (default: http://$(hostname -I | cut -f1 -d ' ')) : "     APP_URL && APP_URL=${APP_URL:-$DEFAULT_APP_URL}
fi

if [ ! "$API_URL" ]; then
read -p "Enter api url (default: http://$(hostname -I | cut -f1 -d ' '):8080) : " API_URL && API_URL=${API_URL:-$DEFAULT_API_URL}
fi

JWT_SECRET=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c32`

echo "MongoDB: $MONGODB_URI"
echo "Redis: $REDIS_URI"
echo "APP Url: $APP_URL"
echo "API Url: $API_URL"
echo "Secret key: $JWT_SECRET"

LICENSE=$(echo $LICENCE | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')
MONGODB_URI=$(echo $MONGODB_URI | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')
REDIS_URI=$(echo $REDIS_URI | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')
APP_URL=$(echo $APP_URL | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')
API_URL=$(echo $API_URL | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')
JWT_SECRET=$(echo $JWT_SECRET | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')

for file in $(find ./conf/* -maxdepth 10 -name "*.js")
do
    config=$(<$file)
    config=`echo $config | sed -e "s/%%LICENCE%%/$LICENCE/g"`
    config=`echo $config | sed -e "s/%%MONGODB_URI%%/$MONGODB_URI/g"`
    config=`echo $config | sed -e "s/%%APP_URL%%/$APP_URL/g"`
    config=`echo $config | sed -e "s/%%API_URL%%/$API_URL/g"`
    config=`echo $config | sed -e "s/%%REDIS_URI%%/$REDIS_URI/g"`
    config=`echo $config | sed -e "s/%%JWT_SECRET%%/$JWT_SECRET/g"`

    echo $config > $file.production
done

for file in $(find ./conf/* -maxdepth 10 -name "*.json")
do
    config=$(<$file)
    config=`echo $config | sed -e "s/%%LICENCE%%/$LICENCE/g"`
    config=`echo $config | sed -e "s/%%MONGODB_URI%%/$MONGODB_URI/g"`
    config=`echo $config | sed -e "s/%%APP_URL%%/$APP_URL/g"`
    config=`echo $config | sed -e "s/%%API_URL%%/$API_URL/g"`
    config=`echo $config | sed -e "s/%%REDIS_URI%%/$REDIS_URI/g"`
    config=`echo $config | sed -e "s/%%JWT_SECRET%%/$JWT_SECRET/g"`

    echo $config > $file.production
done

echo ''
echo 'Starting initialization'
echo ''

docker-compose up -d --quiet-pull --force-recreate --remove-orphans -V
