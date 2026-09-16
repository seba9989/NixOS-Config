{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations."HomeLab-HP" = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.HomeLabHPConfiguration
      self.nixosModules.HomeLabHPHardware
    ];
  };
}
