#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
INSTANCES_DIR="$SCRIPT_DIR/instances"

server_types=(
  "bungee"
  "paper"
  "spigot"
  "velocity"
  "waterfall"
)

server_type="$(printf "%s\n" "${server_types[@]}" | fzf --prompt="Server type > ")"

timestamp=$(date +%Y%m%d%H%M%S)

get_paper_io_version () {
  version=$(curl -s "https://api.papermc.io/v2/projects/$1" | jq -r '.versions[]' | fzf --tac --no-sort --prompt="Version > ")
  echo "$version"
}

get_paper_io_download () {
  build=$(curl -s "https://api.papermc.io/v2/projects/$1/versions/$2" | jq -r '.builds[]' | fzf --tac --no-sort --prompt="Build > ")
  download_url=$(curl -s "https://api.papermc.io/v2/projects/$1/versions/$2/builds/$build" | jq -r '.downloads.application.name')
  echo "https://api.papermc.io/v2/projects/$1/versions/$2/builds/$build/downloads/$download_url"
}

mkdir -p "$INSTANCES_DIR"

if [[ $server_type == 'spigot' ]] ; then
  target_jar=$(find "$SCRIPT_DIR"/.buildtools -maxdepth 1 -name "spigot-1.*.jar" -exec basename {} \; | fzf +s --prompt="Server JAR > ")
  if ! [[ "$target_jar" =~ spigot-1\.([0-9]+)\. ]]; then
    echo "Failed to extract version from jar name"
    exit 1
  fi
  version="${BASH_REMATCH[1]}"
  target_jar="$SCRIPT_DIR/.buildtools/$target_jar"

  echo 'Creating Spigot Server!'
  dir="$INSTANCES_DIR/spigot_$timestamp"

  cp -r "$SCRIPT_DIR/.servers/1_${version}" "$dir"

  pushd "$dir" >& /dev/null
  ln -s "$target_jar" "server.jar"
  cp -rT "$SCRIPT_DIR"/.configs/spigot .
  popd >& /dev/null

  echo "Created server at $dir"
elif [[ $server_type == 'paper' ]] ; then
  version=$(get_paper_io_version "paper")
  version_minor=$(echo "$version" | awk -F'.' '{print $2}')
  download_url=$(get_paper_io_download "paper" "$version")

  echo 'Creating Paper Server!'
  dir="$INSTANCES_DIR/paper_$timestamp"

  cp -r "$SCRIPT_DIR/.servers/1_${version_minor}" "$dir"

  pushd "$dir" >& /dev/null
  curl -Lfs --url "$download_url" -o server.jar
  cp -rT "$SCRIPT_DIR"/.configs/spigot .
  popd >& /dev/null

  echo "Created server at $dir"
elif [[ $server_type == 'bungee' ]] ; then
  echo 'Creating Bungee Server!'
  dir="$INSTANCES_DIR/bungee_$timestamp"

  cp -rd "$SCRIPT_DIR/.servers/bungee" "$dir"

  pushd "$dir" >& /dev/null
  curl -Lfs --url https://ci.md-5.net/job/BungeeCord/lastSuccessfulBuild/artifact/bootstrap/target/BungeeCord.jar -o BungeeCord.jar
  cp -rT "$SCRIPT_DIR"/.configs/bungee .
  popd >& /dev/null

  echo "Created server at $dir"
elif [[ $server_type == 'waterfall' ]] ; then
  version=$(get_paper_io_version "waterfall")
  download_url=$(get_paper_io_download "waterfall" "$version")

  echo 'Creating Waterfall Server!'
  dir="$INSTANCES_DIR/waterfall_$timestamp"

  cp -rd "$SCRIPT_DIR/.servers/bungee" "$dir"

  pushd "$dir" >& /dev/null
  curl -Lfs --url "$download_url" -o BungeeCord.jar
  cp -rT "$SCRIPT_DIR"/.configs/bungee .
  popd >& /dev/null

  echo "Created server at $dir"
elif [[ $server_type == 'velocity' ]] ; then
  version=$(get_paper_io_version "velocity")
  download_url=$(get_paper_io_download "velocity" "$version")

  echo 'Creating Velocity Server!'
  dir="$INSTANCES_DIR/velocity_$timestamp"

  cp -rd "$SCRIPT_DIR/.servers/velocity" "$dir"

  pushd "$dir" >& /dev/null
  curl -Lfs --url "$download_url" -o latest.jar
  cp -rT "$SCRIPT_DIR"/.configs/velocity .
  popd >& /dev/null

  echo "Created server at $dir"
else
  echo 'Unknown server type :('
  exit 1
fi
