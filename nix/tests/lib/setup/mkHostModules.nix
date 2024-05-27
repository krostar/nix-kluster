{
  lib,
  pkgs,
  ...
}: let
  clustersDirPath = ../testdata;
  clustersDir = lib.kluster.setup.readDir clustersDirPath;

  mkHostModules = lib.kluster.setup.mkHostModules clustersDirPath clustersDir;

  host = {
    cluster = "cluster1";
    site = "site1";
    domain = "domain1";
    node = "node1";
  };

  hostModules = mkHostModules host;

  hostModulesJSON = builtins.toJSON hostModules;

  expectedHostModulesJSON = builtins.toJSON [
    (clustersDirPath + "/_config/0.nix")
    (clustersDirPath + "/cluster1/_config/2.nix")
    (clustersDirPath + "/cluster1/_config/users/1.nix")
    (clustersDirPath + "/cluster1/site1/_config/3.nix")
    (clustersDirPath + "/cluster1/site1/_config/4.nix")
    (clustersDirPath + "/cluster1/site1/domain1/_config/5.nix")
    (clustersDirPath + "/cluster1/site1/domain1/node1/6.nix")
    (clustersDirPath + "/cluster1/site1/domain1/node1/foo/bar.nix")
  ];
in
  pkgs.runCommand "test.lib/setup/mkHostModules" {} ''
    ${pkgs.jq}/bin/jq --argjson x '${hostModulesJSON}' -n '$x'
    echo "<- current | expectations ->"
    ${pkgs.jq}/bin/jq --argjson y '${expectedHostModulesJSON}' -n '$y'
    [ "$(${pkgs.jq}/bin/jq --argjson x '${hostModulesJSON}' --argjson y '${expectedHostModulesJSON}' -n '$x == $y')" == "true" ]
    touch $out
  ''
