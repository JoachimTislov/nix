{
  description = "Joachim's NixOS machines";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs = { nixpkgs, ... }:
    let system = "x86_64-linux"; in {
      nixosConfigurations = {
        laptop = nixpkgs.lib.nixosSystem { inherit system; modules = [ ./configuration.nix ./hosts/laptop ]; };
        desktop = nixpkgs.lib.nixosSystem { inherit system; modules = [ ./configuration.nix ./hosts/desktop ]; };
        server = nixpkgs.lib.nixosSystem { inherit system; modules = [ ./configuration.nix ./hosts/server ]; };
      };
    };
}
