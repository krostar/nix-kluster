{
  lib,
  pkgs,
  ...
}: let
  attrJSON = builtins.toJSON (lib.kluster.nodeToAttrs "cluster1" "site1" "domain1" "node1");
  expectedAttrJSON = builtins.toJSON {
    cluster = "cluster1";
    site = "site1";
    domain = "domain1";
    node = "node1";
  };
in
  pkgs.runCommand "test.lib/nodeToAttrs" {} ''
    ${pkgs.jq}/bin/jq --argjson x '${attrJSON}' -n '$x'
    echo "<- current | expectations -> "
    ${pkgs.jq}/bin/jq --argjson y '${expectedAttrJSON}' -n '$y'
    [ "$(${pkgs.jq}/bin/jq --argjson x '${attrJSON}' --argjson y '${expectedAttrJSON}' -n '$x == $y')" == "true" ]
    touch $out
  ''
