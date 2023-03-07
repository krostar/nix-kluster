{
  lib,
  pkgs,
  ...
}: let
  clustersDirPath = ../testdata;
  clustersDir = lib.kluster.setup.readClustersDir clustersDirPath;

  nodeModule = lib.kluster.setup.mkKlusterModule clustersDirPath clustersDir (lib.kluster.nodeToAttrs "cluster1" "site1" "domain1" "node1");
  nodeModuleAttrs = lib.evalModules {modules = [nodeModule];};
  nodeModuleAttrsJSON = builtins.toJSON {
    host = nodeModuleAttrs.config.kluster.host;
    globalConfig = nodeModuleAttrs.config.kluster.data.config;
  };

  expectedNodeModuleAttrsJSON = ''
    {
      "globalConfig": {
        "array": [
          "a"
        ],
        "scope": "global"
      },
      "host": {
        "cluster": "cluster1",
        "domain": "domain1",
        "node": "node1",
        "site": "site1"
      }
    }
  '';
in
  pkgs.runCommand "test.lib/setup/mkKlusterModule" {} ''
    ${pkgs.jq}/bin/jq --argjson x '${nodeModuleAttrsJSON}' -n '$x'
    echo "<- current | expectations -> "
    ${pkgs.jq}/bin/jq --argjson y '${expectedNodeModuleAttrsJSON}' -n '$y'
    [ "$(${pkgs.jq}/bin/jq --argjson x '${nodeModuleAttrsJSON}' --argjson y '${expectedNodeModuleAttrsJSON}' -n '$x == $y')" == "true" ]
    touch $out
  ''
