{self, ...}: {
  flake.nixosModules.workstation = {...}: {
    imports = [
      self.nixosModules.base
      self.nixosModules.niri
      self.nixosModules.seba9989

      self.nixosModules.podman
      self.nixosModules.flatpak
      self.nixosModules.tailscale
      self.nixosModules.steam
    ];
  };
}
