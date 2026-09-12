{ lib, pkgs, ... }:

{
  imports = lib.optional (builtins.pathExists ./hardware-configuration.nix)
    ./hardware-configuration.nix;

  system.stateVersion = "26.05";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Europe/Oslo";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "no";
  services.xserver.xkb.layout = "no";

  networking.hostName = "desktop";
  networking.networkmanager.enable = true;
  programs.zsh.enable = true;

  users.users.joachim = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.graphics.enable = true;
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.open = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  programs.hyprland.enable = true;
  environment.systemPackages = with pkgs; [
    git vim neovim curl wget htop tmux ripgrep fd
    hyprland kitty waybar kdePackages.dolphin emacs pavucontrol blueman
  ];

  environment.shellAliases.rebuild = "sudo nixos-rebuild switch";
}
