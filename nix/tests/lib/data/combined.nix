{
  lib,
  pkgs,
  ...
}: let
  clustersDirPath = ../testdata;
  clustersDir = lib.kluster.setup.readDir clustersDirPath;

  combined = lib.kluster.data.combined {
    host = lib.kluster.hostToAttrs "cluster1" "site1" "domain1" "node1";
    data = lib.kluster.setup.mkData clustersDirPath clustersDir;
  };

  valueJSON = builtins.toJSON combined;
  expectedValueJSON = ''
    {
      "array": [
        "a",
        "c"
      ],
      "foo": 2,
      "bar": {
        "b": false,
        "c": true
      },
      "scope": "node1"
    }
  '';
in
  pkgs.runCommand "test.lib/data/combined" {} ''
    ${pkgs.jq}/bin/jq --argjson x '${valueJSON}' -n '$x'
    echo "<- current | expectations ->"
    ${pkgs.jq}/bin/jq --argjson y '${expectedValueJSON}' -n '$y'
    [ "$(${pkgs.jq}/bin/jq --argjson x '${valueJSON}' --argjson y '${expectedValueJSON}' -n '$x == $y')" == "true" ]
    touch $out
  ''
