{lib}:
/*
returns a list of set containing the following keys:
  - cluster
  - site
  - domain
  - node
  for each node in the cluster config.
*/
klusterConfig:
builtins.map (item: builtins.removeAttrs item ["_klusterMarker"]) (
  lib.collect (value: builtins.isAttrs value && builtins.hasAttr "_klusterMarker" value) (
    lib.mapAttrs (clusterName: cluster: (
      lib.mapAttrs (siteName: site: (
        lib.mapAttrs (domainName: domain: (
          lib.mapAttrs (nodeName: _: {
            _klusterMarker = true;
            cluster = clusterName;
            site = siteName;
            domain = domainName;
            node = nodeName;
          })
          domain.nodes
        ))
        site.domains
      ))
      cluster.sites
    ))
    klusterConfig.original.clusters
  )
)
