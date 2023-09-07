{
  lib,
  pkgs,
  ...
}: let
  clustersDirPath = ../testdata;

  mkKlusterNodeModules = lib.kluster.setup.mkKlusterNodeModules {inherit clustersDirPath;};
  klusterHost = {
    cluster = "cluster1";
    site = "site1";
    domain = "domain1";
    node = "node1";
  };

  nodesModules = mkKlusterNodeModules klusterHost;

  nodesModulesJSON = builtins.toJSON {
    kluster-host = (builtins.elemAt nodesModules 0).config.kluster.host;
    others = lib.drop 1 nodesModules;
  };

  expectedNodesModulesJSON = builtins.toJSON {
    kluster-host = klusterHost;
    others = [
      (clustersDirPath + "/_config/0.nix")
      (clustersDirPath + "/cluster1/_config/2.nix")
      (clustersDirPath + "/cluster1/_config/users/1.nix")
      (clustersDirPath + "/cluster1/site1/_config/3.nix")
      (clustersDirPath + "/cluster1/site1/_config/4.nix")
      (clustersDirPath + "/cluster1/site1/domain1/_config/5.nix")
      (clustersDirPath + "/cluster1/site1/domain1/node1/6.nix")
      (clustersDirPath + "/cluster1/site1/domain1/node1/foo/bar.nix")
    ];
  };
in
  pkgs.runCommand "test.lib/setup/mkKlusterNodeModules" {} ''
    ${pkgs.jq}/bin/jq --argjson x '${nodesModulesJSON}' -n '$x'
    echo "<- current | expectations -> "
    ${pkgs.jq}/bin/jq --argjson y '${expectedNodesModulesJSON}' -n '$y'
    [ "$(${pkgs.jq}/bin/jq --argjson x '${nodesModulesJSON}' --argjson y '${expectedNodesModulesJSON}' -n '$x == $y')" == "true" ]
    touch $out
  ''
