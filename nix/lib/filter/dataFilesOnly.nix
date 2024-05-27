{lib}: let
  cleanEmptyAttrs = import ../cleanEmptyAttrs.nix {inherit lib;};
in
  /*
  keep only _data.nix files inside clustersDir
  */
  clustersDir:
    cleanEmptyAttrs (
      lib.filterAttrsRecursive (
        key: value:
          builtins.isAttrs value
          || (key == "_data.nix" && builtins.isBool value && value)
      )
      clustersDir
    )
