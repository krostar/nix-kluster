{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption;
  cfg = config.kluster;
in {
  options.kluster = {
    cluster = mkOption {
      type = lib.types.str;
      description = lib.mdDoc "The name of the cluster the node is on.";
    };
    site = mkOption {
      type = lib.types.str;
      description = lib.mdDoc "The name of the site the node is on.";
    };
    domain = mkOption {
      type = lib.types.str;
      description = lib.mdDoc "The name of the domain the node is on.";
    };
    node = mkOption {
      type = lib.types.str;
      description = lib.mdDoc "The name of the node.";
    };
  };
}
