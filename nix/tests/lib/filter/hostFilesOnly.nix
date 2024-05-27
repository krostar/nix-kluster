{
  lib,
  pkgs,
  ...
}: let
  clustersDir = lib.kluster.setup.readDir ../testdata;
  clustersDirFiles = builtins.listToAttrs (
    builtins.map (item: {
      name = "${item.cluster}-${item.site}-${item.domain}-${item.node}";
      value = lib.kluster.filter.hostFilesOnly clustersDir item;
    }) [
      (lib.kluster.hostToAttrs "cluster1" "site1" "domain1" "node1")
      (lib.kluster.hostToAttrs "cluster1" "site1" "domain1" "node2")
      (lib.kluster.hostToAttrs "cluster1" "site1" "domain2" "nodeX")
      (lib.kluster.hostToAttrs "cluster1" "site2" "domain1" "nodeX")
      (lib.kluster.hostToAttrs "cluster1" "siteX" "domain1" "node1")
      (lib.kluster.hostToAttrs "cluster2" "siteX" "domainX" "nodeX")
      (lib.kluster.hostToAttrs "clusterX" "siteX" "domainX" "nodeX")
    ]
  );
  clustersDirFilesJSON = builtins.toJSON clustersDirFiles;

  expectedClustersDirFilesJSON = ''
    {
      "cluster1-site1-domain1-node1": {
        "_config": {
          "0.nix": true,
          "_data.nix": true
        },
        "cluster1": {
          "_config": {
            "2.nix": true,
            "_data.nix": true,
            "users": {
              "1.nix": true,
              "_data.nix": true
            }
          },
          "site1": {
            "_config": {
              "3.nix": true,
              "4.nix": true,
              "_data.nix": true
            },
            "domain1": {
              "_config": {
                "5.nix": true,
                "_data.nix": true,
                "foo": false
              },
              "node1": {
                "6.nix": true,
                "_data.nix": true,
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
          "_data.nix": true
        },
        "cluster1": {
          "_config": {
            "2.nix": true,
            "_data.nix": true,
            "users": {
              "1.nix": true,
              "_data.nix": true
            }
          },
          "site1": {
            "_config": {
              "3.nix": true,
              "4.nix": true,
              "_data.nix": true
            },
            "domain1": {
              "_config": {
                "5.nix": true,
                "_data.nix": true,
                "foo": false
              },
              "node2": {
                "_data.nix": true,
                "d.nix": true
              }
            }
          }
        }
      },
      "cluster1-site1-domain2-nodeX": {
        "_config": {
          "0.nix": true,
          "_data.nix": true
        },
        "cluster1": {
          "_config": {
            "2.nix": true,
            "_data.nix": true,
            "users": {
              "1.nix": true,
              "_data.nix": true
            }
          },
          "site1": {
            "_config": {
              "3.nix": true,
              "4.nix": true,
              "_data.nix": true
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
          "_data.nix": true
        },
        "cluster1": {
          "_config": {
            "2.nix": true,
            "_data.nix": true,
            "users": {
              "1.nix": true,
              "_data.nix": true
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
          "_data.nix": true
        },
        "cluster1": {
          "_config": {
            "2.nix": true,
            "_data.nix": true,
            "users": {
              "1.nix": true,
              "_data.nix": true
            }
          }
        }
      },
      "cluster2-siteX-domainX-nodeX": {
        "_config": {
          "0.nix": true,
          "_data.nix": true
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
          "_data.nix": true
        }
      }
    }
  '';
in
  pkgs.runCommand "test.lib/filter/hostFilesOnly" {} ''
    ${pkgs.jq}/bin/jq --argjson x '${clustersDirFilesJSON}' -n '$x'
    echo "<- current | expectations ->"
    ${pkgs.jq}/bin/jq --argjson y '${expectedClustersDirFilesJSON}' -n '$y'
    [ "$(${pkgs.jq}/bin/jq --argjson x '${clustersDirFilesJSON}' --argjson y '${expectedClustersDirFilesJSON}' -n '$x == $y')" == "true" ]
    touch $out
  ''
