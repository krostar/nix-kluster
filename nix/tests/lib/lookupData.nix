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
    a = lib.kluster.lookupData config (lib.kluster.nodeToAttrs "cluster1" "site1" "domain1" "node1") ["scope"];
    b = lib.kluster.lookupData config (lib.kluster.nodeToAttrs "cluster1" "site1" "domain1" "node2") ["scope"];
    c = lib.kluster.lookupData config (lib.kluster.nodeToAttrs "cluster1" "site1" "domain1" "node1") ["bar" "b"];
    d = lib.kluster.lookupData config (lib.kluster.nodeToAttrs "cluster1" "site1" "domain1" "node2") ["bar" "b"];
    e = lib.kluster.lookupData config (lib.kluster.nodeToAttrs "cluster1" "site1" "domain1" "node2") ["foooooo"];
    f = lib.kluster.lookupData config (lib.kluster.nodeToAttrs "notcluster" "notsite" "notdomain" "notnode") ["scope"];
  };

  expectedValueJSON = ''
    {
      "a": {
        "found": true,
        "value": "node1"
      },
      "b": {
        "found": true,
        "value": "node2"
      },
      "c": {
        "found": true,
        "value": false
      },
      "d": {
        "found": true,
        "value": 42
      },
      "e": {
        "found": false,
        "value": null
      },
      "f": {
        "found": true,
        "value": "global"
      }
    }
  '';
in
  pkgs.runCommand "test.lib/lookupData" {} ''
    ${pkgs.jq}/bin/jq --argjson x '${valueJSON}' -n '$x'
    echo "<- current | expectations -> "
    ${pkgs.jq}/bin/jq --argjson y '${expectedValueJSON}' -n '$y'
    [ "$(${pkgs.jq}/bin/jq --argjson x '${valueJSON}' --argjson y '${expectedValueJSON}' -n '$x == $y')" == "true" ]
    touch $out
  ''
