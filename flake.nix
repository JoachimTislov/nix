{
  description = "Joachim's NixOS machines";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs = { nixpkgs, ... }:
    let system = "x86_64-linux"; in {
      nixosConfigurations = {
        laptop = nixpkgs.lib.nixosSystem { inherit system; modules = [ ./laptop.nix ]; };
        desktop = nixpkgs.lib.nixosSystem { inherit system; modules = [ ./desktop.nix ]; };
        server = nixpkgs.lib.nixosSystem { inherit system; modules = [ ./server.nix ]; };
      };
    };
}
