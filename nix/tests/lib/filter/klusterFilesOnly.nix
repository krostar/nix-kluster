{
  lib,
  pkgs,
  ...
}: let
  clustersDir = lib.kluster.setup.readClustersDir ../testdata;

  clustersDirFiltered = lib.kluster.filter.klusterFilesOnly clustersDir;
  clustersDirFilteredJSON = builtins.toJSON clustersDirFiltered;

  expectedFilteredClustersDirJSON = ''
    {
      "_config": {
        "_kluster.nix": true
      },
      "cluster1": {
        "_config": {
          "_kluster.nix": true,
          "users": {
            "_kluster.nix": true
          }
        },
        "site1": {
          "_config": {
            "_kluster.nix": true
          },
          "domain1": {
            "_config": {
              "_kluster.nix": true
            },
            "node1": {
              "_kluster.nix": true
            },
            "node2": {
              "_kluster.nix": true
            }
          }
        }
      }
    }
  '';
in
  pkgs.runCommand "test.lib/filter/klusterFilesOnly" {} ''
    ${pkgs.jq}/bin/jq --argjson x '${clustersDirFilteredJSON}' -n '$x'
    echo "<- current | expectations -> "
    ${pkgs.jq}/bin/jq --argjson y '${expectedFilteredClustersDirJSON}' -n '$y'
    [ "$(${pkgs.jq}/bin/jq --argjson x '${clustersDirFilteredJSON}' --argjson y '${expectedFilteredClustersDirJSON}' -n '$x == $y')" == "true" ]
    touch $out
  ''
