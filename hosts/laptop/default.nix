{ pkgs, ... }:
{
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
  # ASUS UM4251 hardware-configuration.nix belongs here after generation on the laptop.
  environment.systemPackages = with pkgs; [ hyprland kitty neovim waybar dolphin emacs-pgtk ];
}
