_:
/*
kluster nixos module for a given host
*/
data: {
  cluster,
  site,
  domain,
  node,
}: {
  imports = [../../nixos/modules/kluster];
  config = {
    kluster = {
      inherit data;
      host = {inherit cluster site domain node;};
    };
  };
}
