#!/bin/bash

echo ""
echo "    █      Enginsight OnPremise Setup v1.0"
echo "  █ █   █  "
echo "  █ █ █ █  Enginsight GmbH"
echo "  █ █ █ █  Hans-Knöll-Straße 6, 07745 Jena"
echo "  █   █ █  Geschäftsführer: Mario Jandeck, Eric Range"
echo "      █    "
echo ""

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

if ! [ -x "$(command -v docker)" ]; then
  echo 'Error: docker is not installed.' >&2
  exit 1
fi

if ! [ -x "$(command -v docker-compose)" ]; then
  echo 'Error: docker-compose is not installed.' >&2
  exit 1
fi

if [ ! "$MONGODB_URI" ]; then
read -p 'Enter mongodb uri (e.g. mongodb://mongo1:27017,mongo2:27017,mongo3:27017/enginsight?replicaSet=ngs): ' MONGODB_URI
if [ -z "$MONGODB_URI" ]; then
  echo "We need a mongo uri."
  exit 1
fi
fi

if [[ ! $MONGODB_URI == *"replicaSet"* ]] && [[ ! $MONGODB_URI == *"+srv"* ]]; then
  exit 1
fi

if [ ! "$MONGODB_URI" ]; then
read -p 'Enter your licence: ' LICENCE
if [ -z "$LICENCE" ]; then
  echo "We need a licence."
  exit 1
fi
fi

if [ ! "$APP_URL" ]; then
read -p 'Enter app url (default: http://localhost) : '      APP_URL && APP_URL=${APP_URL:-http://localhost}
fi

if [ ! "$API_URL" ]; then
read -p 'Enter api url (default: http://localhost:8080) : ' API_URL && API_URL=${API_URL:-http://localhost:8080}
fi

if [ ! "$COOKIE_DOMAIN" ]; then
read -p 'Enter cookie domain (default: .localhost) : '      COOKIE_DOMAIN && COOKIE_DOMAIN=${COOKIE_DOMAIN:-.localhost}
fi

if [ ! "$REDIS_URI" ]; then
read -p 'Enter redis uri (default: redis://redis:6379) : '  REDIS_URI && REDIS_URI=${REDIS_URI:-redis://redis:6379}
fi

JWT_SECRET=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c32`

for file in $(find ./conf/* -maxdepth 10 -name "*.js|*.json")
do
    cat $file | sed -e "s/%%LICENCE%%/$(echo $LICENCE | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" > $file.production
    cat $file | sed -e "s/%%LICENCE%%/$(echo $LICENCE | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" > $file.production
    cat $file | sed -e "s/%%MONGODB_URI%%/$(echo $MONGODB_URI | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" > $file.production
    cat $file | sed -e "s/%%APP_URL%%/$(echo $APP_URL | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" > $file.production
    cat $file | sed -e "s/%%COOKIE_DOMAIN%%/$(echo $COOKIE_DOMAIN | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" > $file.production
    cat $file | sed -e "s/%%API_URL%%/$(echo $API_URL | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" > $file.production
    cat $file | sed -e "s/%%REDIS_URI%%/$(echo $REDIS_URI | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" > $file.production
    cat $file | sed -e "s/%%JWT_SECRET%%/$(echo $JWT_SECRET | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')/g" > $file.production
done

echo ''
echo 'Starting initialization'
echo ''

docker-compose up
