#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

spigot_plugins=(
  "Citizens"
  "DecentHolograms"
  "LuckPerms-Bukkit"
  "PlaceholderAPI"
  "PlugMan"
  "ProtocolLib"
  "Triton"
  "TritonTestSuite"
  "ViaBackwards"
  "ViaVersion"
)

bungee_plugins=(
  "LuckPerms-Bungee"
  "Triton"
)

velocity_plugins=(
  "LuckPerms-Velocity"
  "Triton"
)

# Spigot
for server_dir in "$SCRIPT_DIR"/1_*/; do
  rm -r "$server_dir"plugins
  mkdir -p "$server_dir"plugins
  for plugin in "${spigot_plugins[@]}"; do
    ln -sf "$SCRIPT_DIR"/../.plugins/"$plugin".jar "$server_dir"plugins/"$plugin".jar
  done
done

# Bungee
server_dir="$SCRIPT_DIR/bungee/"
rm -r "$server_dir"plugins
mkdir -p "$server_dir"plugins
for plugin in "${bungee_plugins[@]}"; do
  ln -sf "$SCRIPT_DIR"/../.plugins/"$plugin".jar "$server_dir"plugins/"$plugin".jar
done

# Velocity
server_dir="$SCRIPT_DIR/velocity/"
rm -r "$server_dir"plugins
mkdir -p "$server_dir"plugins
for plugin in "${velocity_plugins[@]}"; do
  ln -sf "$SCRIPT_DIR"/../.plugins/"$plugin".jar "$server_dir"plugins/"$plugin".jar
done

echo "Created symlinks for all servers"
