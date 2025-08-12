#!/usr/bin/env bash

set -e

SCRIPT=$(readlink -f "$0")
PROJ_PATH=$(dirname "$SCRIPT")

if [[ ! -f "$PROJ_PATH"/BuildTools.jar ]]; then
  curl -L \
    -o "$PROJ_PATH/BuildTools.jar" \
    --url https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
fi

mkdir -p workdir
pushd workdir

bwrap \
  --ro-bind /nix /nix \
  --ro-bind /etc/resolv.conf /etc/resolv.conf \
  --bind "$PROJ_PATH" "$PROJ_PATH" \
  --bind "$HOME/.m2" "$HOME/.m2" \
  --proc /proc \
  --dev /dev \
  --tmpfs /tmp \
  --tmpfs /run \
  --ro-bind /run/current-system /run/current-system \
  --ro-bind /sys /sys \
  --share-net \
  --die-with-parent \
  -- \
  java -jar "$PROJ_PATH"/BuildTools.jar --output-dir "$PROJ_PATH" "$@"

popd
