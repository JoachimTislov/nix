{ pkgs, lib, ... }:
{
  imports = [ ./disko.nix ]
    ++ lib.optional (builtins.pathExists ./hardware-configuration.nix)
      ./hardware-configuration.nix;
  networking.hostName = "zenbook";
  environment.shellAliases.rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#laptop";
  hardware.cpu.amd.updateMicrocode = true;
  hardware.graphics.enable = true;
  hardware.enableRedistributableFirmware = true;
  services.fwupd.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  services.libinput.enable = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  programs.hyprland.enable = true;
  environment.systemPackages = with pkgs; [
    hyprland kitty neovim waybar kdePackages.dolphin emacs pavucontrol blueman
  ];
}
