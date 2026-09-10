{ lib, ... }:
{
  disko.devices.disk.main = {
    type = "disk";
    device = lib.mkDefault "/dev/nvme0n1";
    content = {
      type = "gpt";
      partitions = {
        ESP = { size = "512M"; type = "EF00"; content = { type = "filesystem"; format = "vfat"; mountpoint = "/boot"; }; };
        swap = { size = "16G"; content = { type = "swap"; resumeDevice = true; }; };
        luks = { size = "100%"; content = { type = "luks"; name = "cryptroot"; content = { type = "btrfs"; extraArgs = [ "-f" ]; subvolumes = {
          "/@" = { mountpoint = "/"; mountOptions = [ "compress=zstd" "noatime" ]; };
          "/@home" = { mountpoint = "/home"; mountOptions = [ "compress=zstd" "noatime" ]; };
          "/@log" = { mountpoint = "/var/log"; mountOptions = [ "compress=zstd" "noatime" ]; };
          "/@cache" = { mountpoint = "/var/cache"; mountOptions = [ "compress=zstd" "noatime" ]; };
          "/@snapshots" = { mountpoint = "/.snapshots"; mountOptions = [ "compress=zstd" "noatime" ]; };
        }; }; }; };
      };
    };
  };
}
