{pkgs, ...}: {
  config = {
    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-hard.yaml";

	  targets.vscode.enable = true;

      targets.firefox.colorTheme.enable = true;
      targets.firefox.profileNames = ["default"];
      targets = {
        waybar.addCss = false;
      };

      targets.rofi.enable = false;

      polarity = "dark";

      image = ../../homeManagerModules/desktop/wallpapers/gruvbox-nix.png;

      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 22;
      };

      iconTheme = {
        enable = true;
        package = pkgs.catppuccin-papirus-folders;
        dark = "Papirus-Dark";
        light = "Papirus-Dark";
      };

      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font Mono";
        };
        sansSerif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Sans";
        };
        serif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Serif";
        };
      };

      opacity = {
        applications = 0.9;
        terminal = 0.9;
        desktop = 0.9;
        popups = 0.9;
      };
    };
  };
}
