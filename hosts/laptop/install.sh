#!/usr/bin/env bash
set -Eeuo pipefail
export LC_ALL=C
root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"
[[ -f "$root/flake.nix" ]] || { echo "Could not find flake.nix at $root" >&2; exit 1; }
command -v nmcli >/dev/null || { echo 'nmcli is not available'; exit 1; }
command -v nixos-install >/dev/null || { echo 'nixos-install is not available'; exit 1; }
command -v sfdisk >/dev/null || { echo 'sfdisk is not available'; exit 1; }
command -v cryptsetup >/dev/null || { echo 'cryptsetup is not available'; exit 1; }
command -v mkfs.btrfs >/dev/null || { echo 'btrfs-progs is not available'; exit 1; }
sudo -v
lsblk -d -o PATH,SIZE,MODEL,TYPE
disk="${1:-${disk:-}}"
[[ -n "$disk" ]] || read -r -p 'Target disk (for example nvme0n1): ' disk
[[ "$disk" == /dev/* ]] || disk="/dev/$disk"
[[ "$disk" == /dev/* && -b "$disk" ]] || { echo 'Invalid block device'; exit 1; }
read -r -p "ALL DATA ON $disk WILL BE ERASED. Type ERASE to continue: " confirm
[[ "$confirm" == ERASE ]] || { echo 'Cancelled'; exit 1; }
sudo umount -R /mnt 2>/dev/null || true
ram_mib=$(( $(awk '/MemTotal:/ {print $2}' /proc/meminfo) / 1024 + 1023 ))
sudo wipefs --all "$disk"
printf 'label: gpt\n,512M,U\n,%sM,S\n,,L\n' "$ram_mib" | sudo sfdisk --wipe always "$disk"
part_prefix="$disk"; [[ "$disk" =~ [0-9]$ ]] && part_prefix="${disk}p"
sudo udevadm settle
sudo mkfs.fat -F32 "${part_prefix}1"
sudo mkswap "${part_prefix}2"
sudo swapon "${part_prefix}2"
sudo cryptsetup luksFormat "${part_prefix}3"
sudo cryptsetup open "${part_prefix}3" cryptroot
sudo mkfs.btrfs -f /dev/mapper/cryptroot
sudo mount /dev/mapper/cryptroot /mnt
for subvolume in @ @home @log @cache @snapshots; do sudo btrfs subvolume create "/mnt/$subvolume"; done
sudo umount /mnt
for mount_spec in "@:/mnt" "@home:/mnt/home" "@log:/mnt/var/log" "@cache:/mnt/var/cache" "@snapshots:/mnt/.snapshots"; do
  subvolume="${mount_spec%%:*}"; mountpoint="${mount_spec#*:}"
  sudo mkdir -p "$mountpoint"
  sudo mount -o "subvol=$subvolume,compress=zstd,noatime" /dev/mapper/cryptroot "$mountpoint"
done
sudo mkdir -p /mnt/boot
sudo mount -o umask=0077 "${part_prefix}1" /mnt/boot
nmcli radio wifi on || true
if ! ping -c 1 -W 3 nixos.org >/dev/null 2>&1; then
  nmcli device status
  read -r -p 'Wi-Fi network name (empty for Ethernet): ' wifi
  if [[ -n "$wifi" ]]; then read -r -s -p 'Wi-Fi password: ' password; printf '\n'; nmcli device wifi connect "$wifi" password "$password"; fi
fi
sudo nixos-generate-config --root /mnt --show-hardware-config > "$root/hosts/laptop/hardware-configuration.nix"
sudo mkdir -p /mnt/etc/nixos
sudo cp -a "$root/flake.nix" "$root/flake.lock" "$root/configuration.nix" "$root/hosts" /mnt/etc/nixos/
sudo nixos-install --root /mnt --flake "path:/mnt/etc/nixos#laptop-bootstrap"
