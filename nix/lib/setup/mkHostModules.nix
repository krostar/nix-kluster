{lib}: let
  listClustersDirFiles = import ./listClustersDirFiles.nix {inherit lib;};
  filterClustersDirHostFilesOnly = import ../filter/hostFilesOnly.nix {inherit lib;};
  filterClustersDirNoDataFiles = import ../filter/noDataFiles.nix {inherit lib;};
  filterClustersDirValidNixFilesOnly = import ../filter/validNixFilesOnly.nix {inherit lib;};
  filterClustersDirStopAtDefaultNixFiles = import ../filter/stopAtDefaultNixFiles.nix {inherit lib;};
in
  /*
  returns a given host module list
  */
  clustersDirPath: clustersDir: let
    filteredClustersFiles = filterClustersDirStopAtDefaultNixFiles (filterClustersDirNoDataFiles (filterClustersDirValidNixFilesOnly clustersDir));
  in
    host: listClustersDirFiles clustersDirPath (filterClustersDirHostFilesOnly filteredClustersFiles host)
