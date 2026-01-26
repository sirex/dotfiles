{
  description = "Home Manager configuration of sirex";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nixvim, nvf, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      lib = nixpkgs.lib;

      hosts = {
        home = {
          hasNotes = true;
        };
        server = {
          hasNotes = false;
        };
      };
    in
      {
      homeConfigurations = lib.mapAttrs (host: settings:
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          extraSpecialArgs = {
            inherit nixvim;
            inherit host;
          } // settings;

          modules = [
            nixvim.homeModules.nixvim
            nvf.homeManagerModules.default
            ./home.nix
          ];
        }
      ) hosts;
    };
}
