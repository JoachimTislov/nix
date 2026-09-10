{ pkgs, lib, ... }:
{
  imports = lib.optional (builtins.pathExists ./hardware-configuration.nix)
    ./hardware-configuration.nix;
  networking.hostName = "homelab";
  virtualisation.docker.enable = true;
  services.tailscale.enable = true;
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
  services.caddy.enable = true;
  environment.systemPackages = with pkgs; [ docker-compose restic borgbackup rclone cockpit ];
  # Add a cloudflared module only after its token is managed by a secret tool.
}
