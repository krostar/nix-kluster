{lib}: let
  /*
  returns a set that follows the directory structure of the provided directory by reading its content recursively
    when called by the caller input parameter $dir is the directory containing all clusters files
    then the function calls itself recursively with all directories it finds
    the expected directory structure looks like:
    - _config       <- files imported for all clusters
    - $clusterName  <- name of the cluster regrouping sites
    -- _config      <- files imported for all sites
    -- $siteName    <- name of the site regrouping domains
    --- _config     <- files imported for all domains
    --- $domain     <- name of the domain regrouping nodes
    ---- _config    <- files imported for all nodes
    ---- $node      <- name of the node, with files importe for this specific node
  the set returned contains keys whose values are either
    - a value that is a set (meaning subdirectory)
    - a boolean that is true if the key is a regular file ending with .nix
  */
  readClustersDir = dir:
    lib.filterAttrsRecursive (
      key: value:
        (builtins.isAttrs value && builtins.length (builtins.attrValues value) != 0) || builtins.isBool value
    ) (
      lib.mapAttrs (
        file: type:
          if type == "directory"
          then readClustersDir "${dir}/${file}"
          else (type == "regular" && (lib.hasSuffix ".nix" file))
      ) (builtins.readDir dir)
    );
in
  readClustersDir
