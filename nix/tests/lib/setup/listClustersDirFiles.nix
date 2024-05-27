{
  lib,
  pkgs,
  ...
}: let
  clustersDirPath = ../testdata;
  clustersDir = lib.kluster.filter.dataFilesOnly (lib.kluster.setup.readDir clustersDirPath);

  clustersDirFiles = lib.kluster.setup.listClustersDirFiles clustersDirPath clustersDir;
  clustersDirFilesJSON = builtins.toJSON clustersDirFiles;
  expectedClustersDirFilesJSON = builtins.toJSON [
    (clustersDirPath + "/_config/_data.nix")
    (clustersDirPath + "/cluster1/_config/_data.nix")
    (clustersDirPath + "/cluster1/_config/users/_data.nix")
    (clustersDirPath + "/cluster1/site1/_config/_data.nix")
    (clustersDirPath + "/cluster1/site1/domain1/_config/_data.nix")
    (clustersDirPath + "/cluster1/site1/domain1/node1/_data.nix")
    (clustersDirPath + "/cluster1/site1/domain1/node2/_data.nix")
  ];
in
  pkgs.runCommand "test.lib/setup/listClustersDirFiles" {} ''
    ${pkgs.jq}/bin/jq --argjson x '${clustersDirFilesJSON}' -n '$x'
    echo "<- current | expectations ->"
    ${pkgs.jq}/bin/jq --argjson y '${expectedClustersDirFilesJSON}' -n '$y'
    [ "$(${pkgs.jq}/bin/jq --argjson x '${clustersDirFilesJSON}' --argjson y '${expectedClustersDirFilesJSON}' -n '$x == $y')" == "true" ]
    touch $out
  ''
