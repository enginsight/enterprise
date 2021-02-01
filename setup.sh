#!/bin/bash

echo ""
echo "    █      Enginsight Enterprise Setup v2.0"
echo "  █ █   █  "
echo "  █ █ █ █  Enginsight GmbH"
echo "  █ █ █ █  Hans-Knöll-Straße 6, 07745 Jena"
echo "  █   █ █  Geschäftsführer: Mario Jandeck, Eric Range"
echo "      █    "
echo ""

DEFAULT_APP_URL="http://$(hostname -I | cut -f1 -d ' ')"
DEFAULT_APP_URL_FILE="./conf/DEFAULT_APP_URL.conf"
DEFAULT_API_URL="http://$(hostname -I | cut -f1 -d ' '):8080"
DEFAULT_API_URL_FILE="./conf/DEFAULT_API_URL.conf"

DEFAULT_MONGODB_URI=mongodb://mongodb:27017/enginsight?replicaSet=rs0
DEFAULT_MONGODB_URI_FILE="./conf/DEFAULT_MONGODB_URI.conf"

DEFAULT_REDIS_URI=redis://redis:6379
DEFAULT_REDIS_URI_FILE="./conf/DEFAULT_REDIS_URI.conf"

DEFAULT_JWT_SECRET_FILE="./conf/DEFAULT_JWT_SECRET.conf"

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

if [ -s $DEFAULT_JWT_SECRET_FILE ]; then
    JWT_SECRET=$(cat $DEFAULT_JWT_SECRET_FILE)
else
    JWT_SECRET=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c32`
fi

# Write value to file.
echo $JWT_SECRET > $DEFAULT_JWT_SECRET_FILE

if [ ! "$MONGODB_URI" ]; then
    if [ -s $DEFAULT_MONGODB_URI_FILE ]; then
        DEFAULT_MONGODB_URI=$(cat $DEFAULT_MONGODB_URI_FILE)
    fi

    read -p "Enter MongoDB URI ($DEFAULT_MONGODB_URI): " MONGODB_URI && MONGODB_URI=${MONGODB_URI:-$DEFAULT_MONGODB_URI}
fi

if [[ ! $MONGODB_URI == *"replicaSet"* ]]; then
    echo "Invalid MongoDB URI"
    exit 1
fi

# Write value to file.
echo $MONGODB_URI > $DEFAULT_MONGODB_URI_FILE

if [ ! "$REDIS_URI" ]; then
    if [ -s $DEFAULT_REDIS_URI_FILE ]; then
        DEFAULT_REDIS_URI=$(cat $DEFAULT_REDIS_URI_FILE)
    fi

    read -p "Enter Redis URI ($DEFAULT_REDIS_URI) : " REDIS_URI && REDIS_URI=${REDIS_URI:-$DEFAULT_REDIS_URI}
fi

if [[ ! $REDIS_URI == *"redis://"* ]]; then
    echo "Invalid Redis URI"
    exit 1
fi

# Write value to file.
echo $REDIS_URI > $DEFAULT_REDIS_URI_FILE

if [ ! "$APP_URL" ]; then
    if [ -s $DEFAULT_APP_URL_FILE ]; then
        DEFAULT_APP_URL=$(cat $DEFAULT_APP_URL_FILE)
    fi

    read -p "Enter APP URL ($DEFAULT_APP_URL) : " APP_URL && APP_URL=${APP_URL:-$DEFAULT_APP_URL}
fi

if [[ ! $APP_URL == *"http"* ]]; then
    echo "Invalid APP URL"
    exit 1
fi

# Write value to file.
echo $APP_URL > $DEFAULT_APP_URL_FILE

if [ ! "$API_URL" ]; then
    if [ -s $DEFAULT_API_URL_FILE ]; then
        DEFAULT_API_URL=$(cat $DEFAULT_API_URL_FILE)
    fi

    read -p "Enter API URL ($DEFAULT_API_URL) : " API_URL && API_URL=${API_URL:-$DEFAULT_API_URL}
fi

if [[ ! $API_URL == *"http"* ]]; then
    echo "Invalid APP URL"
    exit 1
fi

# Write value to file.
echo $API_URL > $DEFAULT_API_URL_FILE
echo ""

# Show values in a table.
for val in "MONGODB_URI" "REDIS_URI" "APP_URL" "API_URL" "JWT_SECRET"; do printf "%12s %s\n" "$val:" "${!val}"; done

# Go through all config files...
for file in $(find ./conf/* -maxdepth 10 -name "*.json" -o -name "*.js")
do
    config=$(<$file)

    for name in "MONGODB_URI" "REDIS_URI" "APP_URL" "API_URL" "JWT_SECRET"; do
        # Sanitize invalid json characters.
        value=$(echo ${!name} | sed -e 's/\\/\\\\/g; s/\//\\\//g; s/&/\\\&/g')

        # Replace value from config template.
        config=`echo $config | sed -e "s/%%$name%%/$value/g"`
    done

    # Save the new config to the ".production" file.
    echo $config > $file.production
done

echo ''
echo 'Starting initialization...'
echo ''

docker-compose up -d --force-recreate --remove-orphans -V
