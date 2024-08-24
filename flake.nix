{
  description = "My Home Manager configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, ... }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
      };
    in
    {
      homeConfigurations = {
        dylanchen1 = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          # Pass pkgs-unstable to the home-manager configuration
          extraSpecialArgs = {
            inherit pkgs-unstable;
          };
          modules = [
            ./home-manager/home.nix
          ];
        };
      };
    };
}

