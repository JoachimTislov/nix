# Joachim's NixOS configurations

Persistent home for the NixOS setup. Targets are `laptop` (ASUS UM4251),
`desktop` (current Intel/NVIDIA workstation), and `server` (Docker, Tailscale,
Caddy, backups and homelab base).

The host modules are intentionally hardware-neutral until each machine's disks,
filesystems and boot mode are known. Generate hardware details on the target
machine before installing:

```sh
sudo nixos-generate-config --show-hardware-config > hosts/laptop/hardware-configuration.nix
```

Each host has a self-contained interactive installer. Copy the relevant
`install.sh` together with the repository to a USB, then run it from the
repository root:

```sh
bash hosts/laptop/install.sh
bash hosts/desktop/install.sh
bash hosts/server/install.sh
```

The matching script interactively selects and formats the target disk, then
uses the declarative Disko layout in `hosts/*/disko.nix`: a 512 MiB EFI
partition, swap, encrypted LUKS root, and Btrfs subvolumes with
`compress=zstd,noatime`. The small shell wrapper only selects the disk and
invokes the flake. Disko erases the selected disk; confirm it carefully.

Change `laptop` to `desktop` or `server` as appropriate, review all disk UUIDs,
boot settings and filesystems, then build with:

```sh
nixos-rebuild build --flake .#laptop
```

No disks are formatted by this repository. The optional hardware import means
`nix flake check` and evaluation work before those files exist, while deployment
still requires the generated file. Add Btrfs, Snapper, Restic, Cloudflare Tunnel
and optional homelab services only after choosing storage and secret paths.

The `desktop` and `laptop` targets enable Hyprland and install the core desktop
applications used by the dotfiles. The `server` target remains headless and
enables Docker, Tailscale, SSH and Caddy.
