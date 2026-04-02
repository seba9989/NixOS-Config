{self, ...}: {
  flake.nixosModules.LaptopConfiguration = {pkgs, ...}: {
    networking.hostName = "Laptop";
    imports = [
      self.nixosModules.base
      self.nixosModules.niri
      self.nixosModules.seba9989
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
