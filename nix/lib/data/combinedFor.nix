{lib}:
/*
returns a node combined attributes
*/
{
  host ? {},
  data,
  ...
}: {
  cluster ? host.cluster,
  site ? host.site,
  domain ? host.domain,
  node ? host.node,
}:
lib.attrByPath [
  "clusters"
  host.cluster
  "sites"
  host.site
  "domains"
  host.domain
  "nodes"
  host.node
  "config"
] {}
data.combined
