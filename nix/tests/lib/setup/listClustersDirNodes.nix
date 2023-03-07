{
  lib,
  pkgs,
  ...
}: let
  clustersDir = lib.kluster.setup.readClustersDir ../testdata;

  nodes = lib.kluster.setup.listClustersDirNodes clustersDir;
  nodesJSON = builtins.toJSON nodes;

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
  pkgs.runCommand "test.lib/setup/listClustersDirNodes" {} ''
    ${pkgs.jq}/bin/jq --argjson x '${nodesJSON}' -n '$x'
    ${pkgs.jq}/bin/jq --argjson y '${expectedNodesJSON}' -n '$y'
    [ "$(${pkgs.jq}/bin/jq --argjson x '${nodesJSON}' --argjson y '${expectedNodesJSON}' -n '$x == $y')" == "true" ]
    touch $out
  ''
