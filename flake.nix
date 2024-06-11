{
  description = "Basic NixOS flake";

  inputs = {
    # NixOS official packages source
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };
  
  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
	# Load the default configuration.nix
        ./configuration.nix
	./home-manager/flake.nix
      ];
    };
  };
}
