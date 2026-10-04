{self, ...}: {
  flake.nixosModules.LaptopConfiguration = {...}: {
    networking.hostName = "Laptop";
    imports = [
      self.nixosModules.workstation
    ];

    preferences.monitors = {
      "eDP-1" = {
        primary = true;
        width = 1920;
        height = 1200;
        refreshRate = 60.0;
      };
    };
  };
}
