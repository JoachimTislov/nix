{ config, ... }:
{
  networking.hostName = "desktop";
  hardware.cpu.intel.updateMicrocode = true;
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.open = true;
  # Current desktop hardware: Intel Coffee Lake + RTX 2070 SUPER.
  # Add generated hardware-configuration.nix before deployment.
}
