#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PLUGINS_DIR="$SCRIPT_DIR/.plugins"

declare -A plugins
plugins["Citizens"]="jenkins-http https://ci.citizensnpcs.co/job/Citizens2/lastSuccessfulBuild/ 'Citizens-[^-]+-b[0-9]+\.jar'"
plugins["DecentHolograms"]="github-latest DecentSoftware-eu/DecentHolograms"
plugins["LuckPerms-Bukkit"]="luckperms bukkit"
plugins["LuckPerms-Bungee"]="luckperms bungee"
plugins["LuckPerms-Velocity"]="luckperms velocity"
plugins["PlaceholderAPI"]="hangar PlaceholderAPI PAPER"
plugins["PlugMan"]="github-latest Test-Account666/PlugManX"
plugins["ProtocolLib"]="http https://github.com/dmulloy2/ProtocolLib/releases/download/dev-build/ProtocolLib.jar"
# TODO: plugins["TritonTestSuite"]
plugins["ViaBackwards"]="hangar ViaBackwards PAPER"
plugins["ViaVersion"]="hangar ViaVersion PAPER"

jenkins-http() {
  response=$(curl -fs "$1")
  if ! [[ "$response" =~ $2 ]]; then
    echo "Failed to find link to JAR in response"
    exit 1
  fi
  artifact_name="${BASH_REMATCH[0]}"
  http "$1/artifact/dist/target/$artifact_name" "$3"
}

github-latest() {
  url=$(curl -Lfs \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    --url "https://api.github.com/repos/$1/releases/latest" | jq -r '.assets[0].browser_download_url')
  http "$url" "$2"
}

luckperms() {
  url=$(curl -fs "https://metadata.luckperms.net/data/all" | jq -r .downloads."$1")
  http "$url" "$2"
}

hangar() {
  version=$(curl -fs "https://hangar.papermc.io/api/v1/projects/$1/latestrelease")
  http "https://hangar.papermc.io/api/v1/projects/$1/versions/$version/$2/download" "$3"
}

http() {
  curl -Lfs \
    -o "$PLUGINS_DIR/$2.jar" \
    --url "$1"
}

mkdir -p "$PLUGINS_DIR"

for plugin in "${!plugins[@]}"; do
  if [[ ! -f "$PLUGINS_DIR/$plugin.jar" ]]; then
    echo "Downloading $plugin..."
    opts="${plugins[$plugin]}"
    eval "$opts" "$plugin"
  fi
done

echo "Downloaded all missing plugins"
