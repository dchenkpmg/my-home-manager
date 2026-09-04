{
  description = "My Home Manager configuration for MacOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    ...
  }: let
    system = "aarch64-darwin";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  in {
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
