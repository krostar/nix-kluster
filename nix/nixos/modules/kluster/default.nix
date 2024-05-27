{
  config,
  lib,
  ...
}: let
  inherit (lib) types mkOption;
in {
  options.kluster = {
    data = {
      original = {
        config = mkOption {
          type = types.attrs;
          description = lib.mdDoc "Any attributes that is focusing on all clusters.";
          default = {};
        };
        clusters = mkOption {
          type = types.attrsOf (types.submodule {
            options = {
              config = mkOption {
                type = types.attrs;
                description = lib.mdDoc "Any attributes that is focusing on all sites of the cluster.";
                default = {};
              };
              sites = mkOption {
                type = types.attrsOf (types.submodule {
                  options = {
                    config = mkOption {
                      type = types.attrs;
                      description = lib.mdDoc "Any attributes that is focusing on all domains of the site.";
                      default = {};
                    };
                    domains = mkOption {
                      type = types.attrsOf (types.submodule {
                        options = {
                          config = mkOption {
                            type = types.attrs;
                            description = lib.mdDoc "Any attributes that is focusing on all nodes of the domain.";
                            default = {};
                          };
                          nodes = mkOption {
                            type = types.attrsOf (types.submodule {
                              options = {
                                config = mkOption {
                                  type = types.attrs;
                                  description = lib.mdDoc "Any attributes that is focusing on this specific node.";
                                  default = {};
                                };
                              };
                            });
                            description = lib.mdDoc "Name of the node part of the domain.";
                            default = {};
                          };
                        };
                      });
                      description = lib.mdDoc "Name of the domain part of the site.";
                      default = {};
                    };
                  };
                });
                description = lib.mdDoc "Name of the site part of the cluster.";
                default = {};
              };
            };
          });
          description = lib.mdDoc "Name of the site part of the cluster.";
          default = {};
        };
      };

      combined = {
        config = mkOption {
          type = types.attrs;
          description = lib.mdDoc "All attributes scoped to all clusters.";
          default = {};
        };
        clusters = mkOption {
          type = types.attrsOf (types.submodule {
            options = {
              config = mkOption {
                type = types.attrs;
                description = lib.mdDoc "All attributes scoped to all cluster's sites.";
                default = {};
              };
              sites = mkOption {
                type = types.attrsOf (types.submodule {
                  options = {
                    config = mkOption {
                      type = types.attrs;
                      description = lib.mdDoc "All attributes scoped to all cluster's site's domains.";
                      default = {};
                    };
                    domains = mkOption {
                      type = types.attrsOf (types.submodule {
                        options = {
                          config = mkOption {
                            type = types.attrs;
                            description = lib.mdDoc "All attributes scoped to all cluster's site's domain's nodes.";
                            default = {};
                          };
                          nodes = mkOption {
                            type = types.attrsOf (types.submodule {
                              options = {
                                config = mkOption {
                                  type = types.attrs;
                                  description = lib.mdDoc "All attributes scoped to the cluster's site's domain's node.";
                                  default = {};
                                };
                              };
                            });
                            description = lib.mdDoc "Name of the node part of the domain.";
                            default = {};
                          };
                        };
                      });
                      description = lib.mdDoc "Name of the domain part of the site.";
                      default = {};
                    };
                  };
                });
                description = lib.mdDoc "Name of the site part of the cluster.";
                default = {};
              };
            };
          });
          description = lib.mdDoc "Name of the site part of the cluster.";
          default = {};
        };
      };
    };

    host = {
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
  };
}
