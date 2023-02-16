{pkgs, ...}: let
  clustersTree = pkgs.callPackage ../lib/readClustersTree.nix {} ./testdata;
  nodesList = pkgs.callPackage ../lib/mkNodesList.nix {} clustersTree;

  expectedNodesList = [
    {
      cluster = "cluster1";
      site = "site1";
      domain = "domain1";
      node = "host1";
    }
    {
      cluster = "cluster1";
      site = "site1";
      domain = "domain1";
      node = "host2";
    }
    {
      cluster = "cluster1";
      site = "site2";
      domain = "domain1";
      node = "host1";
    }
  ];

  nodesListJSON = builtins.toJSON nodesList;
  expectedNodesListJSON = builtins.toJSON expectedNodesList;
in
  pkgs.runCommand "test.mkNodesList" {} ''
    ${pkgs.jq}/bin/jq --argjson x '${nodesListJSON}' -n '$x'
    ${pkgs.jq}/bin/jq --argjson y '${expectedNodesListJSON}' -n '$y'
    [ "$(${pkgs.jq}/bin/jq --argjson x '${nodesListJSON}' --argjson y '${expectedNodesListJSON}' -n '$x == $y')" == "true" ]
    touch $out
  ''
