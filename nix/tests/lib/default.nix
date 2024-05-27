{pkgs, ...}:
builtins.listToAttrs (
  builtins.map (item: {
    name = item;
    value = pkgs.callPackage (./. + "/${item}.nix") {};
  })
  [
    "data/combined"
    "data/combinedFor"

    "filter/dataFilesOnly"
    "filter/hostFilesOnly"
    "filter/noDataFiles"
    "filter/stopAtDefaultNixFiles"
    "filter/validNixFilesOnly"

    "setup/listClustersDirFiles"
    "setup/listClustersDirHosts"
    "setup/mkData"
    "setup/mkHostModules"
    "setup/mkHostsModules"
    "setup/mkModule"
    "setup/readDir"

    "cleanEmptyAttrs"
    "hostToAttrs"
    "recursiveMerge"
  ]
)
