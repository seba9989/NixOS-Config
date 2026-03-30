{inputs, self, ...}: {
  flake.homeConfigurations.seba9989 = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs {system = "x86_64-linux";};
    modules = [
      self.homeModules.vesktop
      {
        home.username = "seba9989";
        home.homeDirectory = "/home/seba9989";
        home.stateVersion = "25.11";
      }
    ];
  };
}
