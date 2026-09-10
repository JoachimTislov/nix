{ pkgs, lib, ... }:
{
  imports = lib.optional (builtins.pathExists ./hardware-configuration.nix)
    ./hardware-configuration.nix;
  networking.hostName = "zenbook";
  hardware.cpu.amd.updateMicrocode = true;
  hardware.graphics.enable = true;
  hardware.enableRedistributableFirmware = true;
  services.fwupd.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  services.libinput.enable = true;
  zramSwap.enable = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  programs.hyprland.enable = true;
  environment.systemPackages = with pkgs; [
    hyprland kitty neovim waybar dolphin emacs-pgtk pavucontrol blueman
  ];
}
