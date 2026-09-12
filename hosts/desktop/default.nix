{ pkgs, lib, ... }:
{
  imports = if builtins.pathExists ./hardware-configuration.nix
    then [ ./hardware-configuration.nix ]
    else [ ./disko.nix ];
  networking.hostName = "desktop";
  environment.shellAliases.rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#desktop";
  hardware.cpu.intel.updateMicrocode = true;
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.open = true;
  programs.hyprland.enable = true;
  environment.systemPackages = with pkgs; [
    hyprland kitty neovim waybar kdePackages.dolphin emacs pavucontrol blueman
  ];
}
