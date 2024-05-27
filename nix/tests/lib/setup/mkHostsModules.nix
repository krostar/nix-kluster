{
  lib,
  pkgs,
  ...
}: let
  clustersDirPath = ../testdata;

  hostNamer = {host, ...}: "${host.domain}.${host.node}";

  hostsModules = builtins.mapAttrs (_: modules: {
    config = (builtins.elemAt modules 0).config.kluster.host;
    modules = lib.drop 1 modules;
  }) (lib.kluster.setup.mkHostsModules clustersDirPath hostNamer);

  hostsModulesJSON = builtins.toJSON hostsModules;

  expectedHostsModulesJSON = builtins.toJSON {
    "domain1.node1" = {
      config = lib.kluster.hostToAttrs "cluster1" "site1" "domain1" "node1";
      modules = [
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
    "domain1.node2" = {
      config = lib.kluster.hostToAttrs "cluster1" "site1" "domain1" "node2";
      modules = [
        (clustersDirPath + "/_config/0.nix")
        (clustersDirPath + "/cluster1/_config/2.nix")
        (clustersDirPath + "/cluster1/_config/users/1.nix")
        (clustersDirPath + "/cluster1/site1/_config/3.nix")
        (clustersDirPath + "/cluster1/site1/_config/4.nix")
        (clustersDirPath + "/cluster1/site1/domain1/_config/5.nix")
        (clustersDirPath + "/cluster1/site1/domain1/node2/d.nix")
      ];
    };
  };
in
  pkgs.runCommand "test.lib/setup/mkHostsModules" {} ''
    ${pkgs.jq}/bin/jq --argjson x '${hostsModulesJSON}' -n '$x'
    echo "<- current | expectations ->"
    ${pkgs.jq}/bin/jq --argjson y '${expectedHostsModulesJSON}' -n '$y'
    [ "$(${pkgs.jq}/bin/jq --argjson x '${hostsModulesJSON}' --argjson y '${expectedHostsModulesJSON}' -n '$x == $y')" == "true" ]
    touch $out
  ''
