{
  lib,
  pkgs,
  ...
}: let
  clustersDir = lib.kluster.setup.readDir ../testdata;

  hosts = lib.kluster.setup.listClustersDirHosts clustersDir;
  hostsJSON = builtins.toJSON hosts;

  expectedHostsJSON = builtins.toJSON [
    {
      cluster = "cluster1";
      site = "site1";
      domain = "domain1";
      node = "node1";
    }
    {
      cluster = "cluster1";
      site = "site1";
      domain = "domain1";
      node = "node2";
    }
    {
      cluster = "cluster1";
      site = "site2";
      domain = "domain1";
      node = "node1";
    }
  ];
in
  pkgs.runCommand "test.lib/setup/listClustersDirHosts" {} ''
    ${pkgs.jq}/bin/jq --argjson x '${hostsJSON}' -n '$x'
    ${pkgs.jq}/bin/jq --argjson y '${expectedHostsJSON}' -n '$y'
    [ "$(${pkgs.jq}/bin/jq --argjson x '${hostsJSON}' --argjson y '${expectedHostsJSON}' -n '$x == $y')" == "true" ]
    touch $out
  ''
