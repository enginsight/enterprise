#!/bin/bash

# Download the file using curl
curl --create-dirs -o "pulsar/version.fixed" "https://get.enginsight.com/pulsar/version"

# Extract a string from the file to name the directory
# This example assumes the file is text and uses a placeholder grep command to simulate extracting content.
# Adjust the grep and awk command according to the content structure of your file.
latest=$(grep -o "[0-9]\+\.[0-9]\+\.[0-9]\+" "pulsar/version.fixed" | tr -d '[:space:]')

# Check if the directory name isn't empty
if [[ -z "$latest" ]]; then
    echo "The latest version could not be determined."
    exit 1
fi

# Base URL where the files are hosted
base_url="https://get.enginsight.com/pulsar/"

# List of files to download
files=(
    "$latest/Enginsight Pulsar.app.sha512"
    "$latest/WinDivert-386.dll.sha512"
    "$latest/WinDivert-amd64.dll.sha512"
    "$latest/WinDivert32.sys.sha512"
    "$latest/WinDivert64-amd64.sys.sha512"
    "$latest/ngs-pulsar-386-nt10.exe"
    "$latest/ngs-pulsar-386-nt10.exe.sha512"
    "$latest/ngs-pulsar-386-setup.exe"
    "$latest/ngs-pulsar-386-setup.exe.sha512"
    "$latest/ngs-pulsar-386.exe"
    "$latest/ngs-pulsar-386.exe.sha512"
    "$latest/ngs-pulsar-amd64"
    "$latest/ngs-pulsar-amd64-nt10.exe"
    "$latest/ngs-pulsar-amd64-nt10.exe.sha512"
    "$latest/ngs-pulsar-amd64-setup.exe"
    "$latest/ngs-pulsar-amd64-setup.exe.sha512"
    "$latest/ngs-pulsar-amd64.exe"
    "$latest/ngs-pulsar-amd64.exe.sha512"
    "$latest/ngs-pulsar-amd64.exe.sha512"
    "$latest/ngs-pulsar-amd64.sha256"
    "$latest/ngs-pulsar-amd64.sha512"
    "$latest/ngs-pulsar-arm"
    "$latest/ngs-pulsar-arm.sha256"
    "$latest/ngs-pulsar-arm.sha512"
    "$latest/ngs-pulsar-arm64"
    "$latest/ngs-pulsar-arm64.exe"
    "$latest/ngs-pulsar-arm64.exe.sha512"
    "$latest/ngs-pulsar-arm64.sha256"
    "$latest/ngs-pulsar-arm64.sha512"
    "$latest/ngs-pulsar-armhf"
    "$latest/ngs-pulsar-armhf.sha256"
    "$latest/ngs-pulsar-armhf.sha512"
    "$latest/ngs-pulsar-darwin"
    "$latest/ngs-pulsar-darwin.sha512"
    "$latest/ngs-pulsar-darwin.zip"
    "$latest/ngs-pulsar-darwin.zip.sha512"
    "$latest/ngs-pulsar-linux_amd64.tar.gz"
    "$latest/ngs-pulsar-linux_amd64.tar.gz.sha256"
    "$latest/ngs-pulsar-linux_amd64.tar.gz.sha512"
    "$latest/ngs-pulsar-linux_arm.tar.gz"
    "$latest/ngs-pulsar-linux_arm.tar.gz.sha256"
    "$latest/ngs-pulsar-linux_arm.tar.gz.sha512"
    "$latest/ngs-pulsar-linux_arm64.tar.gz"
    "$latest/ngs-pulsar-linux_arm64.tar.gz.sha256"
    "$latest/ngs-pulsar-linux_arm64.tar.gz.sha512"
    "$latest/ngs-pulsar-linux_armhf.tar.gz"
    "$latest/ngs-pulsar-linux_armhf.tar.gz.sha256"
    "$latest/ngs-pulsar-linux_armhf.tar.gz.sha512"
    "$latest/ngs-pulsar-setup.exe"
    "$latest/ngs-pulsar-setup.exe.sha512"
    "$latest/ngs-pulsar-win_386-nt10.zip"
    "$latest/ngs-pulsar-win_386-nt10.zip.sha512"
    "$latest/ngs-pulsar-win_386.zip"
    "$latest/ngs-pulsar-win_386.zip.sha512"
    "$latest/ngs-pulsar-win_amd64-nt10.zip"
    "$latest/ngs-pulsar-win_amd64-nt10.zip.sha512"
    "$latest/ngs-pulsar-win_amd64.zip"
    "$latest/ngs-pulsar-win_amd64.zip.sha512"
    "$latest/ngs-pulsar-win_arm64.zip"
    "$latest/ngs-pulsar-win_arm64.zip.sha512"
    "$latest/setup.ps1"
    "$latest/setup.sh"
    "$latest/setup_darwin.sh"
    "$latest/uninstall.ps1"
    "$latest/uninstall.sh"
    "$latest/update.ps1"
    "$latest/update.sh"
    "$latest/systemd/ngs-pulsar.ngs-user.service"
    "$latest/systemd/ngs-pulsar.service"
    "$latest/launchd/com.enginsight.pulsar.plist"
    "$latest/init/ngs-pulsar.conf"
)

# Loop through the list of files and download each one using wget
for file in "${files[@]}"; do
    echo "Downloading $file..."
    encoded_file=$(printf '%s' "$file" | sed 's/ /%20/g')
    curl --create-dirs -o "pulsar/$file" "${base_url}${encoded_file}" --progress-bar
    echo ""
done
