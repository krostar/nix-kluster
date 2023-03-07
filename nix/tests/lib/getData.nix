{
  lib,
  pkgs,
  ...
}: let
  config = builtins.fromJSON ''
    {
      "data": {
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
    }
  '';

  valueJSON = builtins.toJSON {
    a = lib.kluster.getData config (lib.kluster.nodeToAttrs "cluster1" "site1" "domain1" "node1") ["scope"];
    b = lib.kluster.getData config (lib.kluster.nodeToAttrs "cluster1" "site1" "domain1" "node2") ["scope"];
    c = lib.kluster.getData config (lib.kluster.nodeToAttrs "cluster1" "site1" "domain1" "node1") ["bar" "b"];
    d = lib.kluster.getData config (lib.kluster.nodeToAttrs "cluster1" "site1" "domain1" "node2") ["bar" "b"];
    f = lib.kluster.getData config (lib.kluster.nodeToAttrs "notcluster" "notsite" "notdomain" "notnode") ["scope"];
  };

  expectedValueJSON = ''
    {
      "a": "node1",
      "b": "node2",
      "c": false,
      "d": 42,
      "f": "global"
    }
  '';
in
  pkgs.runCommand "test.lib/getData" {} ''
    ${pkgs.jq}/bin/jq --argjson x '${valueJSON}' -n '$x'
    echo "<- current | expectations -> "
    ${pkgs.jq}/bin/jq --argjson y '${expectedValueJSON}' -n '$y'
    [ "$(${pkgs.jq}/bin/jq --argjson x '${valueJSON}' --argjson y '${expectedValueJSON}' -n '$x == $y')" == "true" ]
    touch $out
  ''
