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
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [self.overlays.default];
        };
      in {
        devShells.default = import ./shell.nix {inherit pkgs;};
        checks = import ./nix/tests/lib {inherit pkgs;};
      }
    )
    // {
      overlays = {
        default = _: prev: {
          lib = prev.lib.extend (_: lib: {
            kluster = import ./nix/lib {inherit lib;};
          });
        };
      };

      nixosModules = import ./nixos/modules;
    };
}
