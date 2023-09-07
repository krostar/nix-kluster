{lib}: let
  readClustersDir = import ./readClustersDir.nix {inherit lib;};
  mkKlusterModule = import ./mkKlusterModule.nix {inherit lib;};
  listClustersDirFiles = import ./listClustersDirFiles.nix {inherit lib;};
  filterClustersDirNodeFilesOnly = import ../filter/nodeFilesOnly.nix {inherit lib;};
  filterClustersDirNoKlusterFiles = import ../filter/noKlusterFiles.nix {inherit lib;};
  filterClustersDirValidNixFilesOnly = import ../filter/validNixFilesOnly.nix {inherit lib;};
  filterClustersDirStopAtDefaultNixFiles = import ../filter/stopAtDefaultNixFiles.nix {inherit lib;};
in
  /*
  returns a given node module list
  the provided $clustersDirPath is a path to the clusters directory (as defined in readClustersDir.nix)
  */
  {
    clustersDirPath,
    defaultNixosModules ? [],
  }: let
    clustersDir = filterClustersDirValidNixFilesOnly (readClustersDir clustersDirPath);
    filteredClustersDirNodeFilesOnly = filterClustersDirNodeFilesOnly (filterClustersDirStopAtDefaultNixFiles (filterClustersDirNoKlusterFiles clustersDir));
  in
    node: (
      defaultNixosModules
      ++ [(mkKlusterModule clustersDirPath clustersDir node)]
      ++ listClustersDirFiles clustersDirPath (filteredClustersDirNodeFilesOnly node)
    )
