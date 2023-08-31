{lib, ...}: {
  combined = import ./combined.nix {inherit lib;};
  combinedFor = import ./combinedFor.nix {inherit lib;};
}
