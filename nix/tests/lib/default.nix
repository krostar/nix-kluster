{pkgs, ...}:
builtins.listToAttrs (
  builtins.map (item: {
    name = item;
    value = pkgs.callPackage (./. + "/${item}.nix") {};
  })
  [
    "filter/klusterFilesOnly"
    "filter/nodeFilesOnly"
    "filter/noKlusterFiles"
    "filter/stopAtDefaultNixFiles"
    "filter/validNixFilesOnly"

    "setup/listClustersDirFiles"
    "setup/listClustersDirNodes"
    "setup/mkKlusterModuleData"
    "setup/mkKlusterModule"
    "setup/readClustersDir"

    "cleanEmptyAttrs"
    "getData"
    "lookupData"
    "nodeToAttrs"
  ]
)
