{lib}:
/*
returns a set nixos systems usable as flake's nixosConfigurations
the provided $clustersTreeDir is a path to the clusters directory (as defined in readClustersTree.nix)
*/
{defaultNixosModules ? []}: clustersTreeDir: let
  clustersTree = import ./readClustersTree.nix {inherit lib;} clustersTreeDir;
  listNodeFiles = import ./listNodeFiles.nix {inherit lib;} clustersTree;
  nodesList = import ./mkNodesList.nix {inherit lib;} clustersTree;
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
        }:
          lib.nixosSystem {
            modules =
              defaultNixosModules
              ++ [
                ../modules/kluster
                {
                  kluster = {inherit cluster site domain node;};
                  imports = builtins.map (item: clustersTreeDir + "/${item}") (listNodeFiles cluster site domain node);
                }
              ];
          }
      )
      nodesList
    )
  )
