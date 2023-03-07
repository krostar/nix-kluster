{
  lib,
  pkgs,
  ...
}: let
  clustersDirPath = ../testdata;
  clustersDir = lib.kluster.filter.klusterFilesOnly (lib.kluster.setup.readClustersDir clustersDirPath);

  clustersFiles = lib.kluster.setup.listClustersDirFiles clustersDirPath clustersDir;
  clustersFilesJSON = builtins.toJSON clustersFiles;
  expectedClustersFilesJSON = builtins.toJSON [
    (clustersDirPath + "/_config/_kluster.nix")
    (clustersDirPath + "/cluster1/_config/_kluster.nix")
    (clustersDirPath + "/cluster1/_config/users/_kluster.nix")
    (clustersDirPath + "/cluster1/site1/_config/_kluster.nix")
    (clustersDirPath + "/cluster1/site1/domain1/_config/_kluster.nix")
    (clustersDirPath + "/cluster1/site1/domain1/node1/_kluster.nix")
    (clustersDirPath + "/cluster1/site1/domain1/node2/_kluster.nix")
  ];
in
  pkgs.runCommand "test.lib/setup/listClustersDirFiles" {} ''
    ${pkgs.jq}/bin/jq --argjson x '${clustersFilesJSON}' -n '$x'
    echo "<- current | expectations -> "
    ${pkgs.jq}/bin/jq --argjson y '${expectedClustersFilesJSON}' -n '$y'
    [ "$(${pkgs.jq}/bin/jq --argjson x '${clustersFilesJSON}' --argjson y '${expectedClustersFilesJSON}' -n '$x == $y')" == "true" ]
    touch $out
  ''
