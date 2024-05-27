{lib, ...}: {
  dataFilesOnly = import ./dataFilesOnly.nix {inherit lib;};
  hostFilesOnly = import ./hostFilesOnly.nix {inherit lib;};
  noDataFiles = import ./noDataFiles.nix {inherit lib;};
  stopAtDefaultNixFiles = import ./stopAtDefaultNixFiles.nix {inherit lib;};
  validNixFilesOnly = import ./validNixFilesOnly.nix {inherit lib;};
}
