{ pkgs, ... }:
{
  # Keep this at the release used for the first install of each machine.
  system.stateVersion = "26.05";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  time.timeZone = "Europe/Oslo";
  i18n.defaultLocale = "en_US.UTF-8";
  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };
  networking.networkmanager.enable = true;
  programs.zsh.enable = true;
  users.users.joachim = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" ];
  };
  environment.systemPackages = with pkgs; [
    git vim curl wget htop tmux ripgrep fd btrfs-progs snapper
  ];

  # Shared storage policy. Host modules remain free to add host-specific
  # applications and services without changing the filesystem policy.
  services.snapper = {
    snapshotRootOnBoot = true;
    persistentTimer = true;
    configs.root = {
      SUBVOLUME = "/";
      FSTYPE = "btrfs";
      TIMELINE_CREATE = true;
      TIMELINE_CLEANUP = true;
      NUMBER_CLEANUP = true;
      NUMBER_MIN_AGE = "1800";
      NUMBER_LIMIT = "10";
      NUMBER_LIMIT_IMPORTANT = "5";
      TIMELINE_LIMIT_HOURLY = "24";
      TIMELINE_LIMIT_DAILY = "7";
      TIMELINE_LIMIT_WEEKLY = "4";
      TIMELINE_LIMIT_MONTHLY = "6";
      TIMELINE_LIMIT_YEARLY = "2";
    };
  };
}
