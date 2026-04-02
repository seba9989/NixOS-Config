{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.Desktop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.DesktopConfiguration
      self.nixosModules.DesktopHardware
    ];
  };
}
