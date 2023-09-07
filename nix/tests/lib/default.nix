{pkgs, ...}:
builtins.listToAttrs (
  builtins.map (item: {
    name = item;
    value = pkgs.callPackage (./. + "/${item}.nix") {};
  })
  [
    "data/combined"

    "filter/klusterFilesOnly"
    "filter/nodeFilesOnly"
    "filter/noKlusterFiles"
    "filter/stopAtDefaultNixFiles"
    "filter/validNixFilesOnly"

    "setup/listClustersDirFiles"
    "setup/listClustersDirNodes"
    "setup/mkKlusterData"
    "setup/mkKlusterModule"
    "setup/mkKlusterNodeModules"
    "setup/readClustersDir"

    "cleanEmptyAttrs"
    "listNodes"
    "nodeToAttrs"
    "recursiveMerge"
  ]
)
