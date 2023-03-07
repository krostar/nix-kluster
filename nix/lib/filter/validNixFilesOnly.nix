{lib}: let
  cleanEmptyAttrs = import ../cleanEmptyAttrs.nix {inherit lib;};
in
  /*
  filter out all non regular nix files
  */
  clustersDir:
    cleanEmptyAttrs (
      lib.filterAttrsRecursive (
        _: value:
          builtins.isAttrs value || (builtins.isBool value && value == true)
      )
      clustersDir
    )
