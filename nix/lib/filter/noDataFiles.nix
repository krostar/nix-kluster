{lib}: let
  cleanEmptyAttrs = import ../cleanEmptyAttrs.nix {inherit lib;};
in
  /*
  remove all kluster files from clustersDir
  */
  clustersDir:
    cleanEmptyAttrs (
      lib.filterAttrsRecursive (
        key: value:
          !(key == "_data.nix" && builtins.isBool value)
      )
      clustersDir
    )
