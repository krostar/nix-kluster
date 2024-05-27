{lib}: let
  cleanEmptyAttrs = import ../cleanEmptyAttrs.nix {inherit lib;};
in
  /*
  keep only files a host is concerned with
  */
  clustersDir: {
    cluster,
    site,
    domain,
    node,
  }:
    cleanEmptyAttrs {
      "_config" = lib.attrByPath ["_config"] {} clustersDir;
      "${cluster}" = {
        "_config" = lib.attrByPath [cluster "_config"] {} clustersDir;
        "${site}" = {
          "_config" = lib.attrByPath [cluster site "_config"] {} clustersDir;
          "${domain}" = {
            "_config" = lib.attrByPath [cluster site domain "_config"] {} clustersDir;
            "${node}" = lib.attrByPath [cluster site domain node] {} clustersDir;
          };
        };
      };
    }
