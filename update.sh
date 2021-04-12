#!/bin/bash

echo ""
echo "    █      Enginsight Auto-Updater"
echo "  █ █   █  "
echo "  █ █ █ █  Enginsight GmbH"
echo "  █ █ █ █  Hans-Knöll-Straße 6, 07745 Jena"
echo "  █   █ █  Geschäftsführer: Mario Jandeck, Eric Range"
echo "      █    "
echo ""

latest_versions=$(curl -q https://raw.githubusercontent.com/enginsight/enterprise/master/docker-compose.yml 2>/dev/null)

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
  if [[ $latest_versions =~ $regex ]]; then
    latest="${BASH_REMATCH[1]}"

    printf "%16s %8s %8s\n" "$service:" "$latest" "Is now latest version!"

    sed -i "s/\/$service:.*/\/$service:$latest/" ./docker-compose.yml
  fi

done

echo ""
echo "Restarting instance..."

docker-compose up -d --force-recreate --remove-orphans -V
