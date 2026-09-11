{ lib, pkgs, ... }:
{
  # Small first-generation system for the RAM-backed live ISO. After booting
  # this target, `rebuild` switches to the complete `laptop` configuration.
  programs.hyprland.enable = lib.mkForce false;
  environment.systemPackages = lib.mkForce (with pkgs; [
    git vim curl wget htop tmux ripgrep fd btrfs-progs snapper neovim
  ]);
}
