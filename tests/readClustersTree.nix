{pkgs, ...}: let
  readClustersTree = pkgs.callPackage ../lib/readClustersTree.nix {};

  clustersTree = readClustersTree ./testdata;
  clustersTreeJSON = builtins.toJSON clustersTree;

  expectedClustersTreeJSON = ''
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
                    "host1": {
                        "6.nix": true,
                        "foo": {
                            "bar.nix": true
                        }
                    },
                    "host2": {
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
                    "host1": {
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
  pkgs.runCommand "test.readClustersTree" {} ''
    ${pkgs.jq}/bin/jq --argjson x '${clustersTreeJSON}' -n '$x'
    ${pkgs.jq}/bin/jq --argjson y '${expectedClustersTreeJSON}' -n '$y'
    [ "$(${pkgs.jq}/bin/jq --argjson x '${clustersTreeJSON}' --argjson y '${expectedClustersTreeJSON}' -n '$x == $y')" == "true" ]
    touch $out
  ''
