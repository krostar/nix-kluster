{pkgs, ...}:
builtins.listToAttrs (
  builtins.map (item: {
    name = item;
    value = pkgs.callPackage (./. + "/${item}.nix") {};
  })
  [
    "listNodeFiles"
    "mkNodesList"
    "readClustersTree"
  ]
)
