#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [[ -z "$TRITON_GIT_DIR" ]]; then
  echo "TRITON_GIT_DIR environment variable not set"
  echo "Please set it to the path of the dir containing the root of the Triton git repository"
  exit 1
fi

if [[ "$#" -lt 1 ]]; then
  echo "ERROR: missing version"
  echo "Usage: $0 <version>"
  exit 1
fi

version=$1

echo "Creating release... v$version!"

mkdir -p "$SCRIPT_DIR/builds"
cp "$TRITON_GIT_DIR/build/libs/Triton-$version-all.jar" "$SCRIPT_DIR/builds/Triton-v$version.jar"

echo Finished!
