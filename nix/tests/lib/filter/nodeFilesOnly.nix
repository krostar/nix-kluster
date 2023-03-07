{
  lib,
  pkgs,
  ...
}: let
  clustersDir = lib.kluster.setup.readClustersDir ../testdata;
  clustersDirFiltered = builtins.listToAttrs (
    builtins.map (item: {
      name = "${item.cluster}-${item.site}-${item.domain}-${item.node}";
      value = lib.kluster.filter.nodeFilesOnly clustersDir item;
    }) [
      (lib.kluster.nodeToAttrs "cluster1" "site1" "domain1" "node1")
      (lib.kluster.nodeToAttrs "cluster1" "site1" "domain1" "node2")
      (lib.kluster.nodeToAttrs "cluster1" "site1" "domain2" "nodeX")
      (lib.kluster.nodeToAttrs "cluster1" "site2" "domain1" "nodeX")
      (lib.kluster.nodeToAttrs "cluster1" "siteX" "domain1" "node1")
      (lib.kluster.nodeToAttrs "cluster2" "siteX" "domainX" "nodeX")
      (lib.kluster.nodeToAttrs "clusterX" "siteX" "domainX" "nodeX")
    ]
  );
  clustersDirFilteredJSON = builtins.toJSON clustersDirFiltered;

  expectedFilteredClustersDirJSON = ''
    {
      "cluster1-site1-domain1-node1": {
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
          "site1": {
            "_config": {
              "3.nix": true,
              "4.nix": true,
              "_kluster.nix": true
            },
            "domain1": {
              "_config": {
                "5.nix": true,
                "_kluster.nix": true,
                "foo": false
              },
              "node1": {
                "6.nix": true,
                "_kluster.nix": true,
                "foo": {
                  "bar.nix": true
                }
              }
            }
          }
        }
      },
      "cluster1-site1-domain1-node2": {
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
          "site1": {
            "_config": {
              "3.nix": true,
              "4.nix": true,
              "_kluster.nix": true
            },
            "domain1": {
              "_config": {
                "5.nix": true,
                "_kluster.nix": true,
                "foo": false
              },
              "node2": {
                "_kluster.nix": true,
                "d.nix": true
              }
            }
          }
        }
      },
      "cluster1-site1-domain2-nodeX": {
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
          "site1": {
            "_config": {
              "3.nix": true,
              "4.nix": true,
              "_kluster.nix": true
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
          }
        }
      },
      "cluster1-site2-domain1-nodeX": {
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
          "site2": {
            "_config": {
              "f.nix": true
            }
          }
        }
      },
      "cluster1-siteX-domain1-node1": {
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
          }
        }
      },
      "cluster2-siteX-domainX-nodeX": {
        "_config": {
          "0.nix": true,
          "_kluster.nix": true
        },
        "cluster2": {
          "_config": {
            "g.nix": true
          }
        }
      },
      "clusterX-siteX-domainX-nodeX": {
        "_config": {
          "0.nix": true,
          "_kluster.nix": true
        }
      }
    }
  '';
in
  pkgs.runCommand "test.lib/filter/nodeFilesOnly" {} ''
    ${pkgs.jq}/bin/jq --argjson x '${clustersDirFilteredJSON}' -n '$x'
    echo "<- current | expectations -> "
    ${pkgs.jq}/bin/jq --argjson y '${expectedFilteredClustersDirJSON}' -n '$y'
    [ "$(${pkgs.jq}/bin/jq --argjson x '${clustersDirFilteredJSON}' --argjson y '${expectedFilteredClustersDirJSON}' -n '$x == $y')" == "true" ]
    touch $out
  ''
