{
  inputs,
  self,
  ...
}:
{
  flake = {
    nixosModules.seba9989 =
      { pkgs, ... }:
      {
        imports = [
          inputs.home-manager.nixosModules.home-manager
          inputs.catppuccin.nixosModules.catppuccin
        ];

        catppuccin.enable = true;

        users.users.seba9989 = {
          isNormalUser = true;
          description = "Seba9989";
          extraGroups = [
            "networkmanager"
            "wheel"
          ];

          shell = pkgs.fish;
        };

        home-manager = {
          backupFileExtension = "${self.lastModifiedDate or "unknown"}.backup-home";
          users.seba9989 = {
            imports = [
              self.homeModules.vesktop
              self.homeModules.zen
              self.homeModules.catppuccin
              self.homeModules.fish
              self.homeModules.cursor
              self.homeModules.DevelopmentDefault
            ];

            home.stateVersion = "26.05";

            programs.home-manager.enable = true;

            home.packages = with pkgs; [
              blender
              prusa-slicer
              krita
            ];
          };
        };

        programs = {
          appimage = {
            enable = true;
            binfmt = true;
            package = pkgs.appimage-run.override {
              extraPkgs = pkgs: [ pkgs.xorg.libxshmfence ];
            };
          };
        };

        programs.fish.enable = true;
        fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];

        time.timeZone = "Europe/Warsaw";
      };
  };
}
