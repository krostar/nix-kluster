{lib}:
/*
returns the list of modules a node is concerned with
*/
{
  clustersTreeDir,
  clustersTree,
  defaultNixosModules ? [],
}: let
  listNodeFiles = import ./listNodeFiles.nix {inherit lib;} clustersTree;
in
  {
    cluster,
    site,
    domain,
    node,
  }:
    defaultNixosModules
    ++ [
      ../modules/kluster
      {
        kluster = {inherit cluster site domain node;};
      }
    ]
    ++ builtins.map (item: clustersTreeDir + "/${item}") (listNodeFiles cluster site domain node)
