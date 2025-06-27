#!/usr/bin/env bash

set -e

file=$(mktemp)

if [[ "$#" -lt 3 ]]; then
  echo "Usage: $0 <group> <artifact> <version>"
  exit 1
fi

echo "Group: $1"
echo "Artifact: $2"
echo "Version: $3"

group_path=$(echo "$1" | sed "s/\./\//g")
artifact_path=$(echo "$2" | sed "s/\./\//g")

wget "https://repo.diogotc.com/mirror/$group_path/$artifact_path/$3/$2-$3.jar" -O "$file"

sha256sum "$file" | xxd -r -p | base64

rm "$file"
