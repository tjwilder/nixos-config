{
  description = "Basic NixOS flake";

  inputs = {
    # NixOS official packages source
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  
  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
	# Load the default configuration.nix
        ./configuration.nix
	home-manager.nixosModules.home-manager
	{
	  home-manager.useGlobalPkgs = true;
	  home-manager.useUserPackages = true;
	  home-manager.users.tj = { pkgs, ... }: {
		  home.packages = [ pkgs.atool pkgs.httpie ];
		  #programs.bash.enable = true;

		  # The state version is required and should stay at the version you
		  # originally installed.
		  home.stateVersion = "24.05";
		};
	  # Optionally use home-manager.extraSpecialArgs to pass
	  # arguments to home.nix
	}
      ];
    };
  };
}
