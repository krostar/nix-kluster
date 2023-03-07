{lib, ...}: {
  klusterFilesOnly = import ./klusterFilesOnly.nix {inherit lib;};
  nodeFilesOnly = import ./nodeFilesOnly.nix {inherit lib;};
  noKlusterFiles = import ./noKlusterFiles.nix {inherit lib;};
  stopAtDefaultNixFiles = import ./stopAtDefaultNixFiles.nix {inherit lib;};
  validNixFilesOnly = import ./validNixFilesOnly.nix {inherit lib;};
}
