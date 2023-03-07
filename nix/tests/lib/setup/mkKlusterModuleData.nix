{
  lib,
  pkgs,
  ...
}: let
  clustersDirPath = ../testdata;
  clustersDir = lib.kluster.setup.readClustersDir clustersDirPath;

  klusterConfig = lib.kluster.setup.mkKlusterModuleData clustersDirPath clustersDir;
  klusterConfigJSON = builtins.toJSON klusterConfig;

  expectedKlusterConfigJSON = ''
    {
      "clusters": {
        "cluster1": {
          "config": {
            "array": [
              "c"
            ],
            "foo": 2,
            "scope": "cluster1/users"
          },
          "sites": {
            "site1": {
              "config": {
                "bar": {
                  "b": true
                },
                "scope": "site1"
              },
              "domains": {
                "domain1": {
                  "config": {
                    "bar": {
                      "c": true
                    },
                    "scope": "domain1"
                  },
                  "nodes": {
                    "node1": {
                      "config": {
                        "bar": {
                          "b": false
                        },
                        "scope": "node1"
                      }
                    },
                    "node2": {
                      "config": {
                        "bar": {
                          "b": 42
                        },
                        "scope": "node2"
                      }
                    }
                  }
                }
              }
            }
          }
        }
      },
      "config": {
        "array": [
          "a"
        ],
        "scope": "global"
      }
    }
  '';
in
  pkgs.runCommand "test.lib/setup/mkKlusterModuleData" {} ''
    ${pkgs.jq}/bin/jq --argjson x '${klusterConfigJSON}' -n '$x'
    echo "<- current | expectations -> "
    ${pkgs.jq}/bin/jq --argjson y '${expectedKlusterConfigJSON}' -n '$y'
    [ "$(${pkgs.jq}/bin/jq --argjson x '${klusterConfigJSON}' --argjson y '${expectedKlusterConfigJSON}' -n '$x == $y')" == "true" ]
    touch $out
  ''
