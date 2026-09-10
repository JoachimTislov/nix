{ pkgs, ... }:
{
  networking.hostName = "homelab";
  virtualisation.docker.enable = true;
  services.tailscale.enable = true;
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
  services.caddy.enable = true;
  environment.systemPackages = with pkgs; [ docker-compose restic borgbackup rclone cockpit ];
  # Add Cloudflare Tunnel token through a secret manager before enabling cloudflared.
  # Add server hardware-configuration.nix before deployment.
}
