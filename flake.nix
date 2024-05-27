{
  inputs = {
    nixos.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = {
    self,
    nixos,
    nixpkgs,
    ...
  }: let
    supportedSystems = ["aarch64-linux" "aarch64-darwin" "x86_64-linux" "x86_64-darwin"];
    forEachSupportedSystems = f: builtins.listToAttrs (builtins.map (system: (nixpkgs.lib.nameValuePair system (f system))) supportedSystems);
    pkgsForSystem = system: {
      pkgs ? nixpkgs,
      overlays ? [],
    }: (import pkgs {inherit system overlays;});
  in {
    checks = forEachSupportedSystems (system: let
      pkgs = pkgsForSystem system {
        overlays = [self.overlays.default];
      };
    in
      import ./nix/tests/lib {inherit pkgs;});

    devShells = forEachSupportedSystems (system: {default = import ./nix/shell.nix {pkgs = pkgsForSystem system {};};});

    formatter = forEachSupportedSystems (system: let pkgs = pkgsForSystem system {}; in pkgs.alejandra);

    lib = import ./nix/lib {inherit (nixos) lib;};

    overlays = {
      default = _: prev: {
        lib = prev.lib.extend (_: lib: {
          kluster = import ./nix/lib {inherit lib;};
        });
      };
    };

    nixosModules = import ./nix/nixos/modules;
  };
}
