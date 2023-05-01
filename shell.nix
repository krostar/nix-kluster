{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    bashInteractive
    act
    git
    yamllint

    # go related
    gci
    go_1_19
    gofumpt
    golangci-lint

    # nix related
    alejandra
    deadnix
    manix
    statix
  ];
}
