{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    bashInteractive
    act
    git
    yamllint

    # go related
    gci
    go
    gofumpt
    golangci-lint

    # nix related
    alejandra
    deadnix
    manix
    statix
  ];
}
