{lib}: let
  cleanEmptyAttrs = import ../cleanEmptyAttrs.nix {inherit lib;};
in
  /*
  keep only _kluster.nix files inside clustersDir
  */
  clustersDir:
    cleanEmptyAttrs (
      lib.filterAttrsRecursive (
        key: value:
          builtins.isAttrs value
          || (key == "_kluster.nix" && builtins.isBool value && value == true)
      )
      clustersDir
    )
