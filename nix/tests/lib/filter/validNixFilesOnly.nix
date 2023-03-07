{
  lib,
  pkgs,
  ...
}: let
  clustersDir = lib.kluster.setup.readClustersDir ../testdata;
  clustersDirFiltered = lib.kluster.filter.validNixFilesOnly clustersDir;
  clustersDirFilteredJSON = builtins.toJSON clustersDirFiltered;

  expectedFilteredClustersDirJSON = ''
    {
      "_config": {
        "0.nix": true,
        "_kluster.nix": true
      },
      "cluster1": {
        "_config": {
          "2.nix": true,
          "_kluster.nix": true,
          "users": {
            "1.nix": true,
            "_kluster.nix": true
          }
        },
        "a.nix": true,
        "site1": {
          "_config": {
            "3.nix": true,
            "4.nix": true,
            "_kluster.nix": true
          },
          "b.nix": true,
          "domain1": {
            "_config": {
              "5.nix": true,
              "_kluster.nix": true
            },
            "c.nix": true,
            "node1": {
              "6.nix": true,
              "_kluster.nix": true,
              "foo": {
                "bar.nix": true
              }
            },
            "node2": {
              "_kluster.nix": true,
              "d.nix": true
            }
          },
          "domain2": {
            "_config": {
              "default.nix": true,
              "e.nix": true,
              "sub": {
                "h.nix": true
              }
            }
          }
        },
        "site2": {
          "_config": {
            "f.nix": true
          }
        }
      },
      "cluster2": {
        "_config": {
          "g.nix": true
        }
      }
    }
  '';
in
  pkgs.runCommand "test.lib/filter/validNixFilesOnly" {} ''
    ${pkgs.jq}/bin/jq --argjson x '${clustersDirFilteredJSON}' -n '$x'
    echo "<- current | expectations -> "
    ${pkgs.jq}/bin/jq --argjson y '${expectedFilteredClustersDirJSON}' -n '$y'
    [ "$(${pkgs.jq}/bin/jq --argjson x '${clustersDirFilteredJSON}' --argjson y '${expectedFilteredClustersDirJSON}' -n '$x == $y')" == "true" ]
    touch $out
  ''
