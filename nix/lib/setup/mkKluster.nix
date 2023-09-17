{lib}: let
  readClustersDir = import ./readClustersDir.nix {inherit lib;};
  mkKlusterNodeModules = import ./mkKlusterNodeModules.nix {inherit lib;};
  listClustersDirNodes = import ./listClustersDirNodes.nix {inherit lib;};
  filterClustersDirValidNixFilesOnly = import ../filter/validNixFilesOnly.nix {inherit lib;};
in
  /*
  returns a set nixos systems usable as flake's nixosConfigurations
  the provided $clustersDirPath is a path to the clusters directory (as defined in readClustersDir.nix)
  */
  {
    clustersDirPath, # path to the directory containing all nodes configuration
    defaultNixosModules ? [], # list of nixOS modules to prepend to the nixosSystem.modules attribute
    nixosSystemArgs ? {}, # argument provided to the nixosSystem function, overrided to add the node modules list
    # perNodeAdditionalNixosModules:
    #   list of additional nixOS modules to append to defaultNixosModules list depending on the node
    #   example:
    #     {
    #       cluster1.domain1.site1.node1 = [...];
    #       cluster1.domain1.site1.node2 = [...];
    #     };
    perNodeAdditionalNixosModules ? {},
  }: let
    clustersDir = readClustersDir clustersDirPath;
    buildNodeModules = mkKlusterNodeModules clustersDirPath;
    clustersNodes = listClustersDirNodes (filterClustersDirValidNixFilesOnly clustersDir);
  in
    builtins.listToAttrs (
      builtins.map ({config, ...} @ nixosSystem: {
        name = "${config.networking.hostName}.${config.networking.domain}";
        value = nixosSystem;
      }) (
        builtins.map (host @ {
          cluster,
          site,
          domain,
          node,
        }:
          lib.nixosSystem (
            nixosSystemArgs
            // {
              modules =
                defaultNixosModules
                ++ (lib.attrByPath [cluster site domain node] [] perNodeAdditionalNixosModules)
                ++ (buildNodeModules host);
            }
          ))
        clustersNodes
      )
    )
# {
#   cluster = "krostar"
# }

