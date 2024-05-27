{lib}:
/*
returns a set nixos systems usable as flake's nixosConfigurations
the provided $clustersDirPath is a path to the clusters directory (as defined in readClustersDir.nix)
*/
{
  hostsModules, # list of set containing host and modules key
  nixosSystemArgs ? {}, # argument provided to the nixosSystem function, overrided to add the host modules list
  defaultNixosModules ? [], # list of nixOS modules to prepend to the nixosSystem.modules attribute
  # perHostAdditionalNixosModules:
  #   list of additional nixOS modules to append to defaultNixosModules list depending on the node
  #   example:
  #     {
  #       cluster1.domain1.site1.node1 = [...];
  #       cluster1.domain1.site1.node2 = [...];
  #     };
  perHostAdditionalNixosModules ? {},
}:
builtins.mapAttrs (
  name: modules: let
    host = (builtins.elemAt modules 0).config.kluster.host;
  in
    lib.nixosSystem (
      nixosSystemArgs
      // {
        modules =
          defaultNixosModules
          ++ (lib.attrByPath [host.cluster host.site host.domain host.node] [] perHostAdditionalNixosModules)
          ++ modules;
      }
    )
)
hostsModules
