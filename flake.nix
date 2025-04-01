{
  description = "Flake configration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware?ref=master";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... } @ inputs:
  let
    pkgs = import nixpkgs { system = "x86_64-linux"; };
  in
  {
    nixosConfigurations.x1-10 = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
            ./thinkpad_x1_10/nixos/configuration.nix
        ];
    };
    homeConfigurations.thall = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        ./thinkpad_x1_10/home-manager/home.nix
      ];
    };
  };
}
