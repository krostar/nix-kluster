{lib}: let
  valueFound = found: value: {inherit found value;};
in
  {data, ...} @ klusterConfig: {
    cluster,
    site,
    domain,
    node,
  } @ klusterHost: keys: let
    appendConfig = list: (list ++ ["config"] ++ keys);

    pathGlobal = [];
    pathCluster = pathGlobal ++ ["clusters" cluster];
    pathSite = pathCluster ++ ["sites" site];
    pathDomain = pathSite ++ ["domains" domain];
    pathNode = pathDomain ++ ["nodes" node];
  in
    if (lib.hasAttrByPath (appendConfig pathNode) data)
    then (valueFound true (lib.getAttrFromPath (appendConfig pathNode) data))
    else
      (
        if (lib.hasAttrByPath (appendConfig pathDomain) data)
        then (valueFound true (lib.getAttrFromPath (appendConfig pathDomain) data))
        else
          (
            if (lib.hasAttrByPath (appendConfig pathSite) data)
            then (valueFound true (lib.getAttrFromPath (appendConfig pathSite) data))
            else
              (
                if (lib.hasAttrByPath (appendConfig pathCluster) data)
                then (valueFound true (lib.getAttrFromPath (appendConfig pathCluster) data))
                else
                  (
                    if (lib.hasAttrByPath (appendConfig pathGlobal) data)
                    then (valueFound true (lib.getAttrFromPath (appendConfig pathGlobal) data))
                    else (valueFound false null)
                  )
              )
          )
      )
