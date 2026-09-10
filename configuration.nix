{ pkgs, ... }:
{
  # Keep this at the release used for the first install of each machine.
  system.stateVersion = "26.05";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  time.timeZone = "Europe/Oslo";
  i18n.defaultLocale = "en_US.UTF-8";
  networking.networkmanager.enable = true;
  programs.zsh.enable = true;
  users.users.joachim = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" ];
  };
  environment.systemPackages = with pkgs; [ git vim curl wget htop tmux ripgrep fd ];
}
