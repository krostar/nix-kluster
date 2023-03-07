{lib}:
/*
instantiate the kluster module for a given host
*/
clustersDirPath: clustersDir: let
  mkKlusterModuleData = import ./mkKlusterModuleData.nix {inherit lib;};
  klusterData = mkKlusterModuleData clustersDirPath clustersDir;
in
  {
    cluster,
    site,
    domain,
    node,
  }: {
    imports = [../../../nixos/modules/kluster];
    config = {
      kluster = {
        data = klusterData;
        host = {inherit cluster site domain node;};
      };
    };
  }
