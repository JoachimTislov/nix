{ lib, ... }:
{
  imports = [ ../laptop/disko.nix ];
  disko.devices.disk.main.device = lib.mkDefault "/dev/sda";
}
