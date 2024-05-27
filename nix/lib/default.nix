{lib, ...}: {
  data = import ./data {inherit lib;};
  filter = import ./filter {inherit lib;};
  setup = import ./setup {inherit lib;};

  cleanEmptyAttrs = import ./cleanEmptyAttrs.nix {inherit lib;};
  hostToAttrs = import ./hostToAttrs.nix;
  recursiveMerge = import ./recursiveMerge.nix {inherit lib;};
}
