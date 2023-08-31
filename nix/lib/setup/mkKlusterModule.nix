{lib}: let
  mkKlusterData = import ./mkKlusterData.nix {inherit lib;};
in
  /*
  instantiate the kluster module for a given host
  */
  clustersDirPath: clustersDir: let
    klusterData = mkKlusterData clustersDirPath clustersDir;
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
