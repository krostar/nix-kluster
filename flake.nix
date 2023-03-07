{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    flake-utils,
    nixpkgs,
    ...
  }:
    flake-utils.lib.eachSystem (flake-utils.lib.defaultSystems ++ [flake-utils.lib.system.x86_64-darwin]) (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [self.overlays.lib];
        };
      in {
        checks = import ./nix/tests/lib {inherit pkgs;};
      }
    )
    // {
      lib = import ./nix/lib {inherit (nixpkgs) lib;};

      overlays = {
        lib = final: prev: {
          lib = prev.lib.extend (_: lib: {
            kluster = import ./nix/lib {inherit lib;};
          });
        };
      };

      nixosModules = import ./nixos/modules;
    };
}
