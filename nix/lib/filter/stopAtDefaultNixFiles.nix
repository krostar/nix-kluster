{lib}: let
  cleanEmptyAttrs = import ../cleanEmptyAttrs.nix {inherit lib;};
in
  /*
  if a directory contains a regular nix file named "default.nix"
  then only keep the default.nix file
  instead of all the files in the directory and subdirectories
  */
  clustersDir:
    cleanEmptyAttrs (
      lib.mapAttrsRecursiveCond ( # condition function
        attrs:
          if builtins.hasAttr "default.nix" attrs
          then false
          else true
      ) ( # map function
        _: value:
          if
            builtins.isAttrs value
            && builtins.hasAttr "default.nix" value
            && builtins.isBool value."default.nix"
            && value."default.nix"
          then {"default.nix" = true;}
          else value
      )
      clustersDir
    )
