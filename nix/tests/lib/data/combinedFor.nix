{
  lib,
  pkgs,
  ...
}: let
  klusterConfig = lib.kluster.data.combinedFor (builtins.fromJSON ''
    {
      "host": {
        "cluster": "cluster1",
        "site": "site1",
        "domain": "domain1",
        "node": "node1"
      },
      "combined": {
        "config": {
          "array": [
            "a"
          ],
          "scope": "global"
        },
        "clusters": {
          "cluster1": {
            "config": {
              "array": [
                "a",
                "c"
              ],
              "foo": 2,
              "scope": "cluster1/users"
            },
            "sites": {
              "site1": {
                "config": {
                  "array": [
                    "a",
                    "c"
                  ],
                  "foo": 2,
                  "bar": {
                    "b": true
                  },
                  "scope": "site1"
                },
                "domains": {
                  "domain1": {
                    "config": {
                      "array": [
                        "a",
                        "c"
                      ],
                      "foo": 2,
                      "bar": {
                        "b": true,
                        "c": true
                      },
                      "scope": "domain1"
                    },
                    "nodes": {
                      "node1": {
                        "config": {
                          "array": [
                            "a",
                            "c"
                          ],
                          "foo": 2,
                          "bar": {
                            "b": false,
                            "c": true
                          },
                          "scope": "node1"
                        }
                      },
                      "node2": {
                        "config": {
                          "array": [
                            "a",
                            "c"
                          ],
                          "foo": 2,
                          "bar": {
                            "b": 42,
                            "c": true
                          },
                          "scope": "node2"
                        }
                      }
                    }
                  }
                }
              },
              "site2": {
                "config": {
                  "array": [
                    "a",
                    "c"
                  ],
                  "foo": 2,
                  "scope": "cluster1/users"
                },
                "domains": {
                  "domain1": {
                    "config": {
                      "array": [
                        "a",
                        "c"
                      ],
                      "foo": 2,
                      "scope": "cluster1/users"
                    },
                    "nodes": {
                      "node1": {
                        "config": {
                          "array": [
                            "a",
                            "c"
                          ],
                          "foo": 2,
                          "scope": "cluster1/users"
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  '');

  valueJSON = builtins.toJSON {
    a = klusterConfig {};
    b = klusterConfig {
      node = "node2";
    };
    c = klusterConfig {
      site = "site2";
      node = "node1";
    };
    d = klusterConfig {
      site = "site3";
      node = "node8";
    };
  };

  expectedValueJSON = ''
    {
      "a" = {
        "array": [
          "a",
          "c"
        ],
        "foo": 2,
        "bar": {
          "b": false,
          "c": true
        },
        "scope": "node1"
      },
      "b" = {
        "array": [
          "a",
          "c"
        ],
        "foo": 2,
        "bar": {
          "b": false,
          "c": true
        },
        "scope": "node1"
      },
      "c" = {
        "array": [
          "a",
          "c"
        ],
        "foo": 2,
        "bar": {
          "b": false,
          "c": true
        },
        "scope": "node1"
      },
    }
  '';
in
  pkgs.runCommand "test.lib/data/combinedFor" {} ''
    ${pkgs.jq}/bin/jq --argjson x '${valueJSON}' -n '$x'
    echo "<- current | expectations -> "
    ${pkgs.jq}/bin/jq --argjson y '${expectedValueJSON}' -n '$y'
    [ "$(${pkgs.jq}/bin/jq --argjson x '${valueJSON}' --argjson y '${expectedValueJSON}' -n '$x == $y')" == "true" ]
    touch $out
  ''
