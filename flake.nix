{
  description = "Joachim's NixOS machines";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.disko.url = "github:nix-community/disko/latest";
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";
  outputs = { nixpkgs, disko, ... }:
    let system = "x86_64-linux"; in {
      nixosConfigurations = {
          laptop = nixpkgs.lib.nixosSystem { inherit system; modules = [ disko.nixosModules.disko ./configuration.nix ./hosts/laptop ]; };
          laptop-bootstrap = nixpkgs.lib.nixosSystem { inherit system; modules = [ disko.nixosModules.disko ./configuration.nix ./hosts/laptop ./hosts/laptop/bootstrap.nix ]; };
          desktop = nixpkgs.lib.nixosSystem { inherit system; modules = [ disko.nixosModules.disko ./configuration.nix ./hosts/desktop ]; };
          server = nixpkgs.lib.nixosSystem { inherit system; modules = [ disko.nixosModules.disko ./configuration.nix ./hosts/server ]; };
      };
    };
}
