{pkgs, ...}: let
  clustersTree = pkgs.callPackage ../lib/readClustersTree.nix {} ./testdata;
  listNodeFiles = pkgs.callPackage ../lib/listNodeFiles.nix {} clustersTree;

  nodesFiles = {
    "cluster1.site1.domain1.host1" = listNodeFiles "cluster1" "site1" "domain1" "host1";
    "cluster1.site1.domain1.host2" = listNodeFiles "cluster1" "site1" "domain1" "host2";
    "cluster1.site1.domain2.hostX" = listNodeFiles "cluster1" "site1" "domain2" "hostX";
    "cluster1.site2.domain1.hostX" = listNodeFiles "cluster1" "site2" "domain1" "hostX";
    "cluster1.siteX.domain1.host1" = listNodeFiles "cluster1" "siteX" "domain1" "host1";
    "cluster2.siteX.domainX.hostX" = listNodeFiles "cluster2" "siteX" "domainX" "hostX";
    "clusterX.siteX.domainX.hostX" = listNodeFiles "clusterX" "siteX" "domainX" "hostX";
  };

  expectedNodesFiles = {
    "cluster1.site1.domain1.host1" = [
      "_config/0.nix"
      "cluster1/_config/2.nix"
      "cluster1/_config/users/1.nix"
      "cluster1/site1/_config/3.nix"
      "cluster1/site1/_config/4.nix"
      "cluster1/site1/domain1/_config/5.nix"
      "cluster1/site1/domain1/host1/6.nix"
      "cluster1/site1/domain1/host1/foo/bar.nix"
    ];
    "cluster1.site1.domain1.host2" = [
      "_config/0.nix"
      "cluster1/_config/2.nix"
      "cluster1/_config/users/1.nix"
      "cluster1/site1/_config/3.nix"
      "cluster1/site1/_config/4.nix"
      "cluster1/site1/domain1/_config/5.nix"
      "cluster1/site1/domain1/host2/d.nix"
    ];
    "cluster1.site1.domain2.hostX" = [
      "_config/0.nix"
      "cluster1/_config/2.nix"
      "cluster1/_config/users/1.nix"
      "cluster1/site1/_config/3.nix"
      "cluster1/site1/_config/4.nix"
      "cluster1/site1/domain2/_config/e.nix"
    ];
    "cluster1.site2.domain1.hostX" = [
      "_config/0.nix"
      "cluster1/_config/2.nix"
      "cluster1/_config/users/1.nix"
      "cluster1/site2/_config/f.nix"
    ];
    "cluster1.siteX.domain1.host1" = [
      "_config/0.nix"
      "cluster1/_config/2.nix"
      "cluster1/_config/users/1.nix"
    ];
    "cluster2.siteX.domainX.hostX" = [
      "_config/0.nix"
      "cluster2/_config/g.nix"
    ];
    "clusterX.siteX.domainX.hostX" = [
      "_config/0.nix"
    ];
  };

  nodesFilesJSON = builtins.toJSON nodesFiles;
  expectedNodesFilesJSON = builtins.toJSON expectedNodesFiles;
in
  pkgs.runCommand "test.listNodeFiles" {} ''
    ${pkgs.jq}/bin/jq --argjson x '${nodesFilesJSON}' -n '$x'
    ${pkgs.jq}/bin/jq --argjson y '${expectedNodesFilesJSON}' -n '$y'
    [ "$(${pkgs.jq}/bin/jq --argjson x '${nodesFilesJSON}' --argjson y '${expectedNodesFilesJSON}' -n '$x == $y')" == "true" ]
    touch $out
  ''
