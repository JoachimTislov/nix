# Joachim's NixOS configurations

Persistent home for the NixOS setup. Targets are `laptop` (ASUS UM4251),
`desktop` (current Intel/NVIDIA workstation), and `server` (Docker, Tailscale,
Caddy, backups and homelab base).

Generate hardware details on the target machine before installing:

```sh
sudo nixos-generate-config --show-hardware-config > hosts/laptop/hardware-configuration.nix
```

Change `laptop` to `desktop` or `server` as appropriate, review all disk UUIDs,
boot settings and filesystems, then build with:

```sh
nixos-rebuild build --flake .#laptop
```

No disks are formatted by this repository. Add Btrfs, Snapper, Restic, Cloudflare
Tunnel and optional homelab services only after choosing storage and secret paths.
