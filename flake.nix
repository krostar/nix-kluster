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
        pkgs = import nixpkgs {inherit system;};
      in {
        checks = import ./tests {inherit pkgs;};
      }
    )
    // {
      lib = import ./lib {inherit (nixpkgs) lib;};
      nixosModules = import ./modules;
    };
}
