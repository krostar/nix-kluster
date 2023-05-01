{lib}:
/*
returns a set nixos systems usable as flake's nixosConfigurations
the provided $clustersTreeDir is a path to the clusters directory (as defined in readClustersTree.nix)
*/
{
  clustersDirPath, # path to the directory containing all nodes configuration
  defaultNixosModules ? [], # list of nixOS modules to prepend to the nixosSystem.modules attribute
  nixosSystemArgs ? {}, # argument provided to the nixosSystem function, overrided to add the node modules list
}: let
  readClustersDir = import ./readClustersDir.nix {inherit lib;};
  mkKlusterModule = import ./mkKlusterModule.nix {inherit lib;};
  listClustersDirFiles = import ./listClustersDirFiles.nix {inherit lib;};
  listClustersDirNodes = import ./listClustersDirNodes.nix {inherit lib;};
  filterClustersDirNodeFilesOnly = import ../filter/nodeFilesOnly.nix {inherit lib;};
  filterClustersDirNoKlusterFiles = import ../filter/noKlusterFiles.nix {inherit lib;};
  filterClustersDirValidNixFilesOnly = import ../filter/validNixFilesOnly.nix {inherit lib;};
  filterClustersDirStopAtDefaultNixFiles = import ../filter/stopAtDefaultNixFiles.nix {inherit lib;};

  clustersDir = filterClustersDirValidNixFilesOnly (readClustersDir clustersDirPath);
  clustersNodes = listClustersDirNodes clustersDir;

  filteredClustersDirNodeFilesOnly = filterClustersDirNodeFilesOnly (filterClustersDirStopAtDefaultNixFiles (filterClustersDirNoKlusterFiles clustersDir));
in
  builtins.listToAttrs (
    builtins.map (
      {config, ...} @ nixosSystem: {
        name = "${config.networking.hostName}.${config.networking.domain}";
        value = nixosSystem;
      }
    ) (
      builtins.map (
        item:
          lib.nixosSystem (
            nixosSystemArgs
            // {
              modules =
                defaultNixosModules
                ++ [(mkKlusterModule clustersDirPath clustersDir item)]
                ++ listClustersDirFiles clustersDirPath (filteredClustersDirNodeFilesOnly item);
            }
          )
      )
      clustersNodes
    )
  )
