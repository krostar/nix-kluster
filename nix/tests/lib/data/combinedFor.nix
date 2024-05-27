{
  lib,
  pkgs,
  ...
}: let
  clustersDirPath = ../testdata;
  clustersDir = lib.kluster.setup.readDir clustersDirPath;

  combinedFor = lib.kluster.data.combinedFor {
    host = lib.kluster.hostToAttrs "cluster1" "site1" "domain1" "node1";
    data = lib.kluster.setup.mkData clustersDirPath clustersDir;
  };

  valueJSON = builtins.toJSON {
    a = combinedFor {};
    b = combinedFor {
      node = "node2";
    };
    c = combinedFor {
      site = "site2";
      node = "node1";
    };
    d = combinedFor {
      site = "site3";
      node = "node8";
    };
  };

  expectedValueJSON = ''
    {
      "a": {
        "array": [
          "a",
          "c"
        ],
        "bar": {
          "b": false,
          "c": true
        },
        "foo": 2,
        "scope": "node1"
      },
      "b": {
        "array": [
          "a",
          "c"
        ],
        "bar": {
          "b": 42,
          "c": true
        },
        "foo": 2,
        "scope": "node2"
      },
      "c": {
        "array": [
          "a",
          "c"
        ],
        "foo": 2,
        "scope": "cluster1/users"
      },
      "d": {}
    }
  '';
in
  pkgs.runCommand "test.lib/data/combinedFor" {} ''
    ${pkgs.jq}/bin/jq --argjson x '${valueJSON}' -n '$x'
    echo "<- current | expectations ->"
    ${pkgs.jq}/bin/jq --argjson y '${expectedValueJSON}' -n '$y'
    [ "$(${pkgs.jq}/bin/jq --argjson x '${valueJSON}' --argjson y '${expectedValueJSON}' -n '$x == $y')" == "true" ]
    touch $out
  ''
