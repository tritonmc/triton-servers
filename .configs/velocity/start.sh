#!/usr/bin/env bash

SCRIPT=$(readlink -f "$0")
SCRIPT_PATH=$(dirname "$SCRIPT")
PROJ_PATH=$(realpath "$SCRIPT_PATH/../..")

bwrap \
  --ro-bind /nix /nix \
  --ro-bind /etc/resolv.conf /etc/resolv.conf \
  --bind "$PROJ_PATH" "$PROJ_PATH" \
  --proc /proc \
  --dev /dev \
  --tmpfs /tmp \
  --tmpfs /run \
  --ro-bind /run/current-system /run/current-system \
  --ro-bind /sys /sys \
  --share-net \
  --die-with-parent \
  -- \
  java -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:5006 -jar latest.jar
