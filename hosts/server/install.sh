#!/usr/bin/env bash
set -Eeuo pipefail
root="$(pwd)"
command -v nmcli >/dev/null || { echo 'nmcli is not available'; exit 1; }
command -v nixos-install >/dev/null || { echo 'nixos-install is not available'; exit 1; }
nmcli radio wifi on || true
if ! ping -c 1 -W 3 nixos.org >/dev/null 2>&1; then
  nmcli device status
  read -r -p 'Wi-Fi network name (empty for Ethernet): ' wifi
  if [[ -n "$wifi" ]]; then read -r -s -p 'Wi-Fi password: ' password; printf '\n'; nmcli device wifi connect "$wifi" password "$password"; fi
fi
sudo nixos-generate-config --show-hardware-config > "$root/hosts/server/hardware-configuration.nix"
nixos-rebuild build --flake "$root#server"
read -r -p 'Install server to /mnt? [y/N] ' answer
[[ "$answer" =~ ^[Yy]$ ]] && sudo nixos-install --root /mnt --flake "$root#server"
