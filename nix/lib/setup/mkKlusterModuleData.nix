{lib}:
/*
retrieve all kluster data files and build a unique attribute set containing all values
*/
clustersDirPath: clustersDir: let
  cleanEmptyAttrs = import ../cleanEmptyAttrs.nix {inherit lib;};
  listClustersDirNodes = import ./listClustersDirNodes.nix {inherit lib;};
  listClustersDirFiles = import ./listClustersDirFiles.nix {inherit lib;};
  filterKlusterFilesOnly = import ../filter/klusterFilesOnly.nix {inherit lib;};

  clustersDirKlusterFilesOnly = filterKlusterFilesOnly clustersDir;

  klusterNodes = listClustersDirNodes clustersDir;

  importKlusterFiles = keys:
    lib.foldr (a: b: lib.recursiveUpdate a b) {} (
      builtins.map (item: import item) (
        listClustersDirFiles (
          clustersDirPath + "/${builtins.concatStringsSep "/" keys}"
        ) (
          lib.attrByPath keys {} clustersDirKlusterFilesOnly
        )
      )
    );
in
  cleanEmptyAttrs (
    lib.foldr (a: b: lib.recursiveUpdate a b) {} (
      builtins.map (
        {
          cluster,
          site,
          domain,
          node,
        } @ item: {
          config = importKlusterFiles ["_config"];
          clusters = {
            "${cluster}" = {
              config = importKlusterFiles [cluster "_config"];
              sites = {
                "${site}" = {
                  config = importKlusterFiles [cluster site "_config"];
                  domains = {
                    "${domain}" = {
                      config = importKlusterFiles [cluster site domain "_config"];
                      nodes = {
                        "${node}" = {
                          config = importKlusterFiles [cluster site domain node];
                        };
                      };
                    };
                  };
                };
              };
            };
          };
        }
      )
      klusterNodes
    )
  )
