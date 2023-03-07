{lib, ...}: {
  filter = import ./filter {inherit lib;};
  setup = import ./setup {inherit lib;};

  cleanEmptyAttrs = import ./cleanEmptyAttrs.nix {inherit lib;};
  getData = import ./getData.nix {inherit lib;};
  lookupData = import ./lookupData.nix {inherit lib;};
  nodeToAttrs = import ./nodeToAttrs.nix;
}
