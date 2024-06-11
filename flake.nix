{
  description = "Basic NixOS flake";

  inputs = {
    # NixOS official packages source
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager.url = "path:./home-manager/flake.nix";
  };
  
  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      _modules.args = { inherit home-manager; };
      modules = [
	# Load the default configuration.nix
        ./configuration.nix
      ];
    };
  };
}
