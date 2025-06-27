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

triton_version=$1

mkdir -p "$SCRIPT_DIR/.plugins"
rm -f "$SCRIPT_DIR/.plugins/Triton.jar"
ln "$TRITON_GIT_DIR/build/libs/Triton-$triton_version-all.jar" "$SCRIPT_DIR/.plugins/Triton.jar"

echo "Using Triton $triton_version"
