{
  lib,
  pkgs,
  ...
}: let
  clustersDir = lib.kluster.setup.readDir ../testdata;
  clustersDirFiles = lib.kluster.filter.noDataFiles clustersDir;
  clustersDirFilesJSON = builtins.toJSON clustersDirFiles;

  expectedClustersDirFilesJSON = ''
    {
      "_config": {
        "0.nix": true
      },
      "cluster1": {
        "_config": {
          "2.nix": true,
          "users": {
            "1.nix": true
          }
        },
        "a.nix": true,
        "site1": {
          "_config": {
            "3.nix": true,
            "4.nix": true
          },
          "b.nix": true,
          "domain1": {
            "_config": {
              "5.nix": true,
              "foo": false
            },
            "c.nix": true,
            "foo": false,
            "node1": {
              "6.nix": true,
              "foo": {
                "bar.nix": true
              }
            },
            "node2": {
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
          },
          "domain1": {
            "node1": {
              "foo.txt": false
            }
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
  pkgs.runCommand "test.lib/filter/noDataFiles" {} ''
    ${pkgs.jq}/bin/jq --argjson x '${clustersDirFilesJSON}' -n '$x'
    echo "<- current | expectations ->"
    ${pkgs.jq}/bin/jq --argjson y '${expectedClustersDirFilesJSON}' -n '$y'
    [ "$(${pkgs.jq}/bin/jq --argjson x '${clustersDirFilesJSON}' --argjson y '${expectedClustersDirFilesJSON}' -n '$x == $y')" == "true" ]
    touch $out
  ''
