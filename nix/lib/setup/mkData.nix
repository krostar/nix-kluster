{lib}: let
  cleanEmptyAttrs = import ../cleanEmptyAttrs.nix {inherit lib;};
  recursiveMerge = import ../recursiveMerge.nix {inherit lib;};
  listClustersDirHosts = import ./listClustersDirHosts.nix {inherit lib;};
  listClustersDirFiles = import ./listClustersDirFiles.nix {inherit lib;};
  filterDataFilesOnly = import ../filter/dataFilesOnly.nix {inherit lib;};
in
  /*
  retrieve all kluster data files and build a unique attribute set containing all values
  */
  clustersDirPath: clustersDir: let
    clustersDirDataFilesOnly = filterDataFilesOnly clustersDir;

    klusterHosts = listClustersDirHosts clustersDir;

    importDataFiles = keys:
      lib.foldr lib.recursiveUpdate {} (
        builtins.map import (
          listClustersDirFiles (
            clustersDirPath + "/${builtins.concatStringsSep "/" keys}"
          ) (
            lib.attrByPath keys {} clustersDirDataFilesOnly
          )
        )
      );

    klusterOriginalData = lib.foldr lib.recursiveUpdate {} (
      builtins.map (
        {
          cluster,
          site,
          domain,
          node,
        }: {
          config = importDataFiles ["_config"];
          clusters = {
            "${cluster}" = {
              config = importDataFiles [cluster "_config"];
              sites = {
                "${site}" = {
                  config = importDataFiles [cluster site "_config"];
                  domains = {
                    "${domain}" = {
                      config = importDataFiles [cluster site domain "_config"];
                      nodes = {
                        "${node}" = {
                          config = importDataFiles [cluster site domain node];
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
      klusterHosts
    );
  in
    cleanEmptyAttrs {
      original = klusterOriginalData;
      combined = {
        inherit (klusterOriginalData) config;

        clusters =
          lib.mapAttrs (_: clusterData: {
            config = recursiveMerge [klusterOriginalData.config clusterData.config];
            sites =
              lib.mapAttrs (_: siteData: {
                config = recursiveMerge [klusterOriginalData.config clusterData.config siteData.config];
                domains =
                  lib.mapAttrs (_: domainData: {
                    config = recursiveMerge [klusterOriginalData.config clusterData.config siteData.config domainData.config];
                    nodes =
                      lib.mapAttrs (_: nodeData: {
                        config = recursiveMerge [klusterOriginalData.config clusterData.config siteData.config domainData.config nodeData.config];
                      })
                      domainData.nodes;
                  })
                  siteData.domains;
              })
              clusterData.sites;
          })
          klusterOriginalData.clusters;
      };
    }
