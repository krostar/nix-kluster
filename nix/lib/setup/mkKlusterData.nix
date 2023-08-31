{lib}: let
  cleanEmptyAttrs = import ../cleanEmptyAttrs.nix {inherit lib;};
  recursiveMerge = import ../recursiveMerge.nix {inherit lib;};
  listClustersDirNodes = import ./listClustersDirNodes.nix {inherit lib;};
  listClustersDirFiles = import ./listClustersDirFiles.nix {inherit lib;};
  filterKlusterFilesOnly = import ../filter/klusterFilesOnly.nix {inherit lib;};
in
  /*
  retrieve all kluster data files and build a unique attribute set containing all values
  */
  clustersDirPath: clustersDir: let
    clustersDirKlusterFilesOnly = filterKlusterFilesOnly clustersDir;

    klusterNodes = listClustersDirNodes clustersDir;

    importKlusterFiles = keys:
      lib.foldr lib.recursiveUpdate {} (
        builtins.map import (
          listClustersDirFiles (
            clustersDirPath + "/${builtins.concatStringsSep "/" keys}"
          ) (
            lib.attrByPath keys {} clustersDirKlusterFilesOnly
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
