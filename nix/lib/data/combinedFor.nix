{lib}:
/*
returns a host combined attributes
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
  cluster
  "sites"
  site
  "domains"
  domain
  "nodes"
  node
  "config"
] {}
data.combined
