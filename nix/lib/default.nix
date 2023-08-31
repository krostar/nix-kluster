{lib, ...}: {
  data = import ./data {inherit lib;};
  filter = import ./filter {inherit lib;};
  setup = import ./setup {inherit lib;};

  cleanEmptyAttrs = import ./cleanEmptyAttrs.nix {inherit lib;};
  listNodes = import ./listNodes.nix {inherit lib;};
  nodeToAttrs = import ./nodeToAttrs.nix;
  recursiveMerge = import ./recursiveMerge.nix {inherit lib;};
}
