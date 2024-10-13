{
  description = "Basic NixOS flake";

  inputs = {
    # NixOS official packages source
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    #home-manager.url = "github:nix-community/home-manager/release-24.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    # kickstart-nix-nvim.url = "github:tjwilder/kickstart-nix.nvim/main";
    kickstart-nix-nvim.url = "/home/tj/config/kickstart-nix.nvim/";
    fix-python.url = "github:GuillaumeDesforges/fix-python/master";
  };
  
  outputs = { self, nixpkgs, home-manager,  
      kickstart-nix-nvim, fix-python, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          permittedInsecurePackages = [
            "olm-3.2.16"
          ];
        };
        overlays = [ kickstart-nix-nvim.overlays.default ];
      };
      lib = nixpkgs.lib;
    in {
      nixosConfigurations.tj = nixpkgs.lib.nixosSystem {
        inherit system;
        inherit pkgs;
        specialArgs = {
          inherit inputs;
        };
        modules = [
          # Load the default configuration.nix
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = ".bak";
            home-manager.users.tj = import ./home.nix;
            # Optionally use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      
      };
   };
}
