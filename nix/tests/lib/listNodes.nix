{
  lib,
  pkgs,
  ...
}: let
  nodesJSON = builtins.toJSON (lib.kluster.listNodes {
    "original" = {
      "clusters" = {
        "cluster1" = {
          "sites" = {
            "site1" = {
              "domains" = {
                "domain1" = {
                  "nodes" = {
                    "node1" = {};
                    "node2" = {};
                  };
                };
              };
            };
            "site2" = {
              "domains" = {
                "domain1" = {
                  "nodes" = {
                    "node1" = {};
                  };
                };
              };
            };
          };
        };
      };
    };
  });

  expectedNodesJSON = builtins.toJSON [
    {
      cluster = "cluster1";
      site = "site1";
      domain = "domain1";
      node = "node1";
    }
    {
      cluster = "cluster1";
      site = "site1";
      domain = "domain1";
      node = "node2";
    }
    {
      cluster = "cluster1";
      site = "site2";
      domain = "domain1";
      node = "node1";
    }
  ];
in
  pkgs.runCommand "test.lib/listNodes" {} ''
    ${pkgs.jq}/bin/jq --argjson x '${nodesJSON}' -n '$x'
    ${pkgs.jq}/bin/jq --argjson y '${expectedNodesJSON}' -n '$y'
    [ "$(${pkgs.jq}/bin/jq --argjson x '${nodesJSON}' --argjson y '${expectedNodesJSON}' -n '$x == $y')" == "true" ]
    touch $out
  ''
