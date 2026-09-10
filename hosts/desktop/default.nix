{ pkgs, lib, ... }:
{
  imports = [ ./disko.nix ]
    ++ lib.optional (builtins.pathExists ./hardware-configuration.nix)
      ./hardware-configuration.nix;
  networking.hostName = "desktop";
  environment.shellAliases.rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#desktop";
  hardware.cpu.intel.updateMicrocode = true;
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.open = true;
  programs.hyprland.enable = true;
  environment.systemPackages = with pkgs; [
    hyprland kitty neovim waybar dolphin emacs-pgtk pavucontrol blueman
  ];
}
