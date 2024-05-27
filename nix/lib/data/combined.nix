{lib}: let
  combinedFor = import ./combinedFor.nix {inherit lib;};
in
  /*
  returns the current host combined attributes
  */
  data: combinedFor data {}
