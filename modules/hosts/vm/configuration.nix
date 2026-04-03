{self, ...}: {
  flake.nixosModules.VMConfiguration = {...}: {
    networking.hostName = "VM";
    imports = [
      self.nixosModules.base
      self.nixosModules.niri
      self.nixosModules.seba9989
    ];

    preferences.monitors = {
      "DP-2" = {
        primary = true;
        width = 1920;
        height = 1080;
        refreshRate = 165.0;
      };
    };
  };
}
