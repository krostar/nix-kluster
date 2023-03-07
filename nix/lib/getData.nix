{lib}: let
  lookupData = import ./lookupData.nix {inherit lib;};
in
  {data, ...} @ klusterConfig: {
    cluster,
    site,
    domain,
    node,
  } @ klusterHost: keys: let
    lc = lookupData klusterConfig klusterHost keys;
  in
    if lc.found
    then lc.value
    else (builtins.abort "${builtins.concatStringsSep "." keys} not found in any kluster data")
