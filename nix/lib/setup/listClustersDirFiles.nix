{lib}:
/*
returns the list of nix file paths for all attributes of clustersDir
*/
clustersDirPath: clustersDir:
lib.collect (value: builtins.isPath value) (
  lib.mapAttrsRecursive (
    keys: _: clustersDirPath + "/${builtins.concatStringsSep "/" keys}"
  )
  clustersDir
)
