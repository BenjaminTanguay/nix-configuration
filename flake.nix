{
  description = "Nix Configuration for macOS and Linux";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.darwin.url = "github:LnL7/nix-darwin";
  inputs.home-manager.url = "github:nix-community/home-manager";

  outputs = { self, nixpkgs, home-manager, darwin }:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs { inherit system; };
    in {
      packages.${system} = {
        hello = pkgs.hello;
        default = pkgs.hello; # Use the recommended default attribute
      };

      darwinConfigurations = {
        personal = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          configuration = ./system/mac/personal.nix;
        };

        work = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          configuration = ./system/mac/work.nix;
        };
      };
    };
}

