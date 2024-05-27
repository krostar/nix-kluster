{pkgs, ...}:
pkgs.mkShellNoCC {
  nativeBuildInputs = with pkgs; [
    act
    git
    shellcheck
    shfmt
    yamllint

    # go related
    gci
    go_1_22
    gofumpt
    golangci-lint
    gotools
    govulncheck

    # nix related
    alejandra
    deadnix
    manix
    statix
  ];
  shellHook = ''
    export CGO_ENABLED=0
  '';
}
