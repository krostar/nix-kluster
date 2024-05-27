{lib}: let
  readDir = import ./readDir.nix {inherit lib;};
  mkData = import ./mkData.nix {inherit lib;};
  mkModule = import ./mkModule.nix {inherit lib;};
  mkHostModules = import ./mkHostModules.nix {inherit lib;};
  listClustersDirHosts = import ./listClustersDirHosts.nix {inherit lib;};
  filterClustersDirValidNixFilesOnly = import ../filter/validNixFilesOnly.nix {inherit lib;};
in
  clustersDirPath: systemNamer: let
    clustersDir = readDir clustersDirPath;
    hostModules = mkHostModules clustersDirPath clustersDir;
    data = mkData clustersDirPath clustersDir;
  in
    builtins.listToAttrs (
      builtins.map (
        host: let
          module = mkModule data host;
        in (
          lib.nameValuePair (systemNamer module.config.kluster) ([module] ++ hostModules host)
        )
      ) (listClustersDirHosts (filterClustersDirValidNixFilesOnly clustersDir))
    )
