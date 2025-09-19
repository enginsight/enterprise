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
  response=$(wget -qO- "$1" 2>/dev/null || curl -qf "$1" 2>/dev/null)
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

if ! [ "${1-}" = "update" ]; then
  update
fi

echo ""
echo "      █    Enginsight Auto-Updater"
echo "  █   █ █  "
echo "  █ █ █ █  Enginsight GmbH"
echo "  █ █ █ █  Leutragraben 1, 07743 Jena"
echo "  █ █   █  Geschäftsführer: Mario Jandeck, Eric Range"
echo "    █      "
echo ""

# Pull reference compose to determine latest tags
download "https://raw.githubusercontent.com/enginsight/enterprise/master/docker-compose.yml"

# Ensure local compose exists (avoid partial edits)
if ! [ -f ./docker-compose.yml ]; then
  show_error
  echo "Local docker-compose.yml not found in current directory. Aborting to avoid partial update."
  exit 1
fi

# Make a timestamped backup so we can revert on failure
backup_file="./docker-compose.yml.bak.$(date +%Y%m%d%H%M%S)"
cp -a ./docker-compose.yml "$backup_file" || {
  show_error
  echo "Failed to create backup of docker-compose.yml. Aborting."
  exit 1
}

# Always remove the backup on exit (success or failure)
cleanup() {
  if [ -n "${backup_file:-}" ] && [ -f "$backup_file" ]; then
    rm -f "$backup_file"
  fi
}
trap cleanup EXIT

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

# Update tags in local compose based on latest tags found in reference compose
for service in "${services[@]}"
do
  regex="/$service:([0-9]+\.[0-9]+\.[0-9]+)"
  if [[ $response =~ $regex ]]; then
    latest="${BASH_REMATCH[1]}"

    if [[ "$service" == "server-m2" ]]; then
      # Update server-m2 and also server-m2-N (numbered variants)
      # BusyBox/GNU sed compatible
      sed -i -e "s|\(/server-m2\(-[0-9]\+\)\?:\)[0-9]\+\.[0-9]\+\.[0-9]\+|\1$latest|g" ./docker-compose.yml
      printf "%16s %8s %8s\n" "server-m2:" "$latest" "Is now latest version!"
    else
      sed -i -e "s|\(/$service:\)[0-9]\+\.[0-9]\+\.[0-9]\+|\1$latest|g" ./docker-compose.yml
      printf "%16s %8s %8s\n" "$service:" "$latest" "Is now latest version!"
    fi
  fi
done

check_config

echo ""
echo "Starting initialization..."
echo ""

# Compose detection (prefer 'docker compose', then fall back to 'docker-compose')
COMPOSE_MODE=""
COMPOSE_BIN=""
DOCKER_BIN=""

detect_compose() {
  # Prefer modern docker compose (v2)
  if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
    DOCKER_BIN="$(command -v docker)"
    COMPOSE_MODE="v2"
    return 0
  fi
  
  # Explicit /usr/bin/docker (in case PATH is restricted)
  if [ -x /usr/bin/docker ] && /usr/bin/docker compose version >/dev/null 2>&1; then
    DOCKER_BIN="/usr/bin/docker"
    COMPOSE_MODE="v2"
    return 0
  fi

  # Legacy docker-compose (v1)
  if command -v docker-compose >/dev/null 2>&1; then
    COMPOSE_BIN="$(command -v docker-compose)"
    COMPOSE_MODE="v1"
    return 0
  fi

  if [ -x /usr/local/bin/docker-compose ]; then
    COMPOSE_BIN="/usr/local/bin/docker-compose"
    COMPOSE_MODE="v1"
    return 0
  fi

  if [ -x /usr/bin/docker-compose ]; then
    COMPOSE_BIN="/usr/bin/docker-compose"
    COMPOSE_MODE="v1"
    return 0
  fi
  return 1
}

compose() {
  if [ "$COMPOSE_MODE" = "v2" ]; then
    "$DOCKER_BIN" compose "$@"
  else
    "$COMPOSE_BIN" "$@"
  fi
}

if ! detect_compose; then
  show_error
  echo "Could not find Docker Compose (tried 'docker compose' and 'docker-compose')."
  echo "Reverting docker-compose.yml..."
  mv -f "$backup_file" ./docker-compose.yml
  # backup file will be removed by trap (if it still exists)
  exit 1
fi

echo "Pulling images (compose pull)..."
if ! compose pull; then
  show_error
  echo "compose pull failed. Reverting docker-compose.yml..."
  mv -f "$backup_file" ./docker-compose.yml
  exit 1
fi

echo "Images pulled successfully. Starting containers..."
if compose up -d --force-recreate --remove-orphans -V; then
  echo "Update completed successfully."
  exit 0
else
  show_error
  echo "compose up failed. Reverting docker-compose.yml..."
  mv -f "$backup_file" ./docker-compose.yml
  echo "Attempting to restore previous stack..."
  compose up -d --force-recreate --remove-orphans -V || true
  exit 1
fi
