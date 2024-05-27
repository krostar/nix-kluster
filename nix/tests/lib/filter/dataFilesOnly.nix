{
  lib,
  pkgs,
  ...
}: let
  clustersDir = lib.kluster.setup.readDir ../testdata;

  clustersDirFiles = lib.kluster.filter.dataFilesOnly clustersDir;
  clustersDirFilesJSON = builtins.toJSON clustersDirFiles;

  expectedClustersDirFilesJSON = ''
    {
      "_config": {
        "_data.nix": true
      },
      "cluster1": {
        "_config": {
          "_data.nix": true,
          "users": {
            "_data.nix": true
          }
        },
        "site1": {
          "_config": {
            "_data.nix": true
          },
          "domain1": {
            "_config": {
              "_data.nix": true
            },
            "node1": {
              "_data.nix": true
            },
            "node2": {
              "_data.nix": true
            }
          }
        }
      }
    }
  '';
in
  pkgs.runCommand "test.lib/filter/dataFilesOnly" {} ''
    ${pkgs.jq}/bin/jq --argjson x '${clustersDirFilesJSON}' -n '$x'
    echo "<- current | expectations ->"
    ${pkgs.jq}/bin/jq --argjson y '${expectedClustersDirFilesJSON}' -n '$y'
    [ "$(${pkgs.jq}/bin/jq --argjson x '${clustersDirFilesJSON}' --argjson y '${expectedClustersDirFilesJSON}' -n '$x == $y')" == "true" ]
    touch $out
  ''
