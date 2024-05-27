{
  lib,
  pkgs,
  ...
}: let
  clustersDirPath = ../testdata;
  clustersDir = lib.kluster.setup.readDir clustersDirPath;
  data = lib.kluster.setup.mkData clustersDirPath clustersDir;

  module = lib.kluster.setup.mkModule data (lib.kluster.hostToAttrs "cluster1" "site1" "domain1" "node1");
  moduleAttrs = lib.evalModules {modules = [module];};
  moduleAttrsJSON = builtins.toJSON {
    inherit (moduleAttrs.config.kluster) host;
    reducedConfig = moduleAttrs.config.kluster.data.original.config;
  };

  expectedModuleAttrsJSON = ''
    {
      "reducedConfig": {
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
  pkgs.runCommand "test.lib/setup/mkModule" {} ''
    ${pkgs.jq}/bin/jq --argjson x '${moduleAttrsJSON}' -n '$x'
    echo "<- current | expectations ->"
    ${pkgs.jq}/bin/jq --argjson y '${expectedModuleAttrsJSON}' -n '$y'
    [ "$(${pkgs.jq}/bin/jq --argjson x '${moduleAttrsJSON}' --argjson y '${expectedModuleAttrsJSON}' -n '$x == $y')" == "true" ]
    touch $out
  ''
