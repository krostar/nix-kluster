{
  lib,
  pkgs,
  ...
}: let
  clustersDirPath = ../testdata;
  clustersDir = lib.kluster.setup.readDir clustersDirPath;

  data = lib.kluster.setup.mkData clustersDirPath clustersDir;
  dataJSON = builtins.toJSON data;

  expectedDataJSON = ''
    {
      "original": {
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
        }
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
  '';
in
  pkgs.runCommand "test.lib/setup/mkData" {} ''
    ${pkgs.jq}/bin/jq --argjson x '${dataJSON}' -n '$x'
    echo "<- current | expectations ->"
    ${pkgs.jq}/bin/jq --argjson y '${expectedDataJSON}' -n '$y'
    [ "$(${pkgs.jq}/bin/jq --argjson x '${dataJSON}' --argjson y '${expectedDataJSON}' -n '$x == $y')" == "true" ]
    touch $out
  ''
