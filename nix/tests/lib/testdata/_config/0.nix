{config, ...}: {
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "22.11";
  boot.loader.grub = {
    enable = true;
    devices = ["/dev/sda1"];
  };
  fileSystems."/" = {
    device = "/dev/sda1";
  };
  networking.hostName = config.kluster.host.node;
  networking.domain = "${config.kluster.host.domain}.${config.kluster.host.site}.${config.kluster.host.cluster}";
}
