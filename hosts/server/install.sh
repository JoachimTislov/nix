#!/usr/bin/env bash
set -Eeuo pipefail
root="$(pwd)"
command -v nmcli >/dev/null || { echo 'nmcli is not available'; exit 1; }
command -v nixos-install >/dev/null || { echo 'nixos-install is not available'; exit 1; }
sudo -v
lsblk -d -o PATH,SIZE,MODEL,TYPE
disk="${1:-${disk:-}}"
[[ -n "$disk" ]] || read -r -p 'Target disk (for example nvme0n1): ' disk
[[ "$disk" == /dev/* ]] || disk="/dev/$disk"
[[ "$disk" == /dev/* && -b "$disk" ]] || { echo 'Invalid block device'; exit 1; }
read -r -p "ALL DATA ON $disk WILL BE ERASED. Type ERASE to continue: " confirm
[[ "$confirm" == ERASE ]] || { echo 'Cancelled'; exit 1; }
nmcli radio wifi on || true
if ! ping -c 1 -W 3 nixos.org >/dev/null 2>&1; then
  nmcli device status
  read -r -p 'Wi-Fi network name (empty for Ethernet): ' wifi
  if [[ -n "$wifi" ]]; then read -r -s -p 'Wi-Fi password: ' password; printf '\n'; nmcli device wifi connect "$wifi" password "$password"; fi
fi
sudo nixos-generate-config --no-filesystems --show-hardware-config > "$root/hosts/server/hardware-configuration.nix"
sudo nix --extra-experimental-features 'nix-command flakes' run github:nix-community/disko/latest#disko-install -- --write-efi-boot-entries --flake "$root#server" --disk main "$disk"
