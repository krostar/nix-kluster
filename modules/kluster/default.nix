{
  config,
  lib,
  ...
}: let
  inherit (lib) types mkOption;
  cfg = config.kluster;
in {
  options.kluster = {
    dir = mkOption {
      type = types.path;
      description = lib.mdDoc "Path to the clusters root directory.";
    };
    cluster = mkOption {
      type = types.str;
      description = lib.mdDoc "The name of the cluster the node is on.";
    };
    site = mkOption {
      type = types.str;
      description = lib.mdDoc "The name of the site the node is on.";
    };
    domain = mkOption {
      type = types.str;
      description = lib.mdDoc "The name of the domain the node is on.";
    };
    node = mkOption {
      type = types.str;
      description = lib.mdDoc "The name of the node.";
    };
  };
}
