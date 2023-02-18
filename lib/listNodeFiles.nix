{lib}:
/*
returns the list of nix files that a node is concerned with inside the cluster tree
  $clusterTree is the attribute set returned by readClustersTree.nix
*/
clusterTree: let
  # if a directory contains a regular nix file named "default.nix"
  # then only consider the file default.nix file
  # instead of all the files in the directory and subdirectories
  clusterTreeWithDefaultResponsibleOfChildImports =
    lib.mapAttrsRecursiveCond
    (attrs:
      if builtins.hasAttr "default.nix" attrs
      then false
      else true)
    (
      keys: value:
        if
          builtins.isAttrs value
          && builtins.hasAttr "default.nix" value
          && builtins.isBool value."default.nix"
          && value."default.nix" == true
        then {"default.nix" = true;}
        else value
    )
    clusterTree;

  # filter out all non regular nix files
  clusterTreeValidNixFilesOnly = lib.filterAttrsRecursive (_: value: builtins.isAttrs value || value == true) clusterTreeWithDefaultResponsibleOfChildImports;
in
  cluster: site: domain: node:
    lib.collect (value: builtins.isString value) (
      lib.mapAttrsRecursive (path: _: builtins.concatStringsSep "/" path)
      {
        "_config" = lib.attrByPath ["_config"] {} clusterTreeValidNixFilesOnly;
        "${cluster}" = {
          "_config" = lib.attrByPath [cluster "_config"] {} clusterTreeValidNixFilesOnly;
          "${site}" = {
            "_config" = lib.attrByPath [cluster site "_config"] {} clusterTreeValidNixFilesOnly;
            "${domain}" = {
              "_config" = lib.attrByPath [cluster site domain "_config"] {} clusterTreeValidNixFilesOnly;
              "${node}" = lib.attrByPath [cluster site domain node] {} clusterTreeValidNixFilesOnly;
            };
          };
        };
      }
    )
