{lib}:
/*
returns the list of nix files that a node is concerned with inside the cluster tree
  $clusterTree is the attribute set returned by readClustersTree.nix
*/
clusterTree: let
  clusterTreeValidNixFilesOnly = lib.filterAttrsRecursive (_: value: builtins.isAttrs value || value == true) clusterTree;
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
