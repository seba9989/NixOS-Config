{
  inputs,
  self,
  ...
}: {
  flake = {
    homeConfigurations.seba9989 = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {system = "x86_64-linux";};

      modules = [
        self.homeModules.vesktop
        self.homeModules.zen
        self.homeModules.catppuccin
        self.homeModules.fish
        {
          home.username = "seba9989";
          home.homeDirectory = "/home/seba9989";
          home.stateVersion = "26.05";
        }
      ];
    };
    nixosModules.seba9989 = {pkgs, ...}: {
      imports = [
        inputs.catppuccin.nixosModules.catppuccin
      ];

      catppuccin.enable = true;

      users.users.seba9989 = {
        isNormalUser = true;
        description = "Seba9989";
        extraGroups = ["networkmanager" "wheel"];

        shell = pkgs.fish;
      };

      programs.fish.enable = true;

      programs.steam.enable = true;
      environment.systemPackages = with pkgs; [
        adwsteamgtk
      ];

      time.timeZone = "Europe/Warsaw";
    };
  };
}
