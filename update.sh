#!/bin/bash

function show_error () {
  echo "       Computer says no!"
  echo "             /"
  echo "        ________"
  echo "       |       .|"
  echo "       |  NO!  .|"
  echo "       |       .|"
  echo "       |________|"
  echo "       __|___|__"
  echo " _____|_________|____"
  echo "                    _|"
  echo "                   |"
  echo "                   |"
  echo "                   |"
  echo " ________________  |"
  echo "                 |_|"
  echo ""
  echo ""
}

response=""

function update () {
  echo "Update Enginsight Auto-Updater..."

  download "https://raw.githubusercontent.com/enginsight/enterprise/master/update.sh"

  echo "$response" > ./update.sh

  chmod +x ./update.sh

  ./update.sh "update"

  exit 0
}

function download () {
  response=$(wget -qO- $1 2>/dev/null || curl -qf $1 2>/dev/null)
  exit_code=$?

  if ! [ $exit_code == 0 ]; then
    show_error

    echo "Can not download latest versions. Check your internet connection!"
    exit 1
  fi
}

check_config()
{
  if command -v json_pp &> /dev/null
  then
    config=$(cat conf/services/config.json)
    echo ""

    if echo $config | json_pp >/dev/null 2>&1; then
      echo "Your configuration seems to be correct. Continue..."
    else
      echo "Attention! Your configuration seems to be incorrect."
      echo "Please stick to the JSON format."
      read -p "If you still want to continue, press Enter."
    fi

  fi
}

if ! [ "$1" = "update" ]; then
  update
fi

echo ""
echo "    █      Enginsight Auto-Updater"
echo "  █ █   █  "
echo "  █ █ █ █  Enginsight GmbH"
echo "  █ █ █ █  Hans-Knöll-Straße 6, 07745 Jena"
echo "  █   █ █  Geschäftsführer: Mario Jandeck, Eric Range"
echo "      █    "
echo ""

download "https://raw.githubusercontent.com/enginsight/enterprise/master/docker-compose.yml"

declare -a services=(
  "server-m2"
  "ui-m1"
  "sentinel-m3"
  "reporter-m4"
  "profiler-m22"
  "anomalies-m28"
  "scheduler-m29"
  "updater-m34"
  "generator-m35"
  "historian-m38"
  "themis-m43"
)

for service in "${services[@]}"
do
  regex="/$service:([0-9]+\.[0-9]+\.[0-9]+)"
  if [[ $response =~ $regex ]]; then
    latest="${BASH_REMATCH[1]}"

    printf "%16s %8s %8s\n" "$service:" "$latest" "Is now latest version!"

    sed -i "s/\/$service:.*/\/$service:$latest/" ./docker-compose.yml
  fi

done

check_config

echo ""
echo "Starting initialization..."
echo ""

declare -a docker_compose_paths=(
  "docker-compose"
  "/usr/local/bin/docker-compose"
)

for docker_compose in "${docker_compose_paths[@]}"
do
  if command -v $docker_compose &> /dev/null
  then
    command $docker_compose up -d --force-recreate --remove-orphans -V
    exit 0
  fi
done

show_error
echo "Could not find docker-compose command in:"
echo "${docker_compose_paths[*]}"
exit 1
