{self, ...}: {
  flake.nixosModules.DesktopConfiguration = {...}: {
    networking.hostName = "Desktop";
    imports = [
      self.nixosModules.workstation

      self.nixosModules.VM
      self.nixosModules.ollama
    ];

    preferences.monitors = {
      "DP-2" = {
        primary = true;
        width = 1920;
        height = 1080;
        refreshRate = 165.0;

        x = 1920;
      };
      "HDMI-A-1" = {
        width = 1920;
        height = 1080;
        refreshRate = 75.0;

        VRR.enable = false;
      };
    };
  };
}
