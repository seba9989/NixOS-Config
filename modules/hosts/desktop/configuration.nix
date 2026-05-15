{self, ...}: {
  flake.nixosModules.DesktopConfiguration = {...}: {
    networking.hostName = "Desktop";
    imports = [
      self.nixosModules.base
      self.nixosModules.niri
      self.nixosModules.seba9989

      self.nixosModules.steam
      self.nixosModules.podman
      self.nixosModules.flatpak
      self.nixosModules.VM
      self.nixosModules.ollama
      self.nixosModules.tailscale
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
