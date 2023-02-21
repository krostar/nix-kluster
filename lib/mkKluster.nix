{lib}:
/*
returns a set nixos systems usable as flake's nixosConfigurations
the provided $clustersTreeDir is a path to the clusters directory (as defined in readClustersTree.nix)
*/
{defaultNixosModules ? [], ...} @ args: clustersTreeDir: let
  clustersTree = import ./readClustersTree.nix {inherit lib;} clustersTreeDir;
  nodesList = import ./mkNodesList.nix {inherit lib;} clustersTree;
  mkNodeModulesList = import ./mkNodeModulesList.nix {inherit lib;} {
    inherit defaultNixosModules clustersTree clustersTreeDir;
  };
  nixosSystemArg = builtins.removeAttrs args ["defaultNixosModules"];
in
  builtins.listToAttrs (
    builtins.map (
      {config, ...} @ nixosSystem: {
        name = "${config.networking.hostName}.${config.networking.domain}";
        value = nixosSystem;
      }
    ) (
      builtins.map (
        {
          cluster,
          site,
          domain,
          node,
        } @ item:
          lib.nixosSystem (nixosSystemArg // {modules = mkNodeModulesList item;})
      )
      nodesList
    )
  )
