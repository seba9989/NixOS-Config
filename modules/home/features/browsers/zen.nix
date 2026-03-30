{inputs, ...}: {
  flake.homeModules.zen = {pkgs, ...}: {
    imports = [
      inputs.zen-browser.homeModules.beta
      inputs.stylix.homeModules.stylix
    ];

    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

      targets.zen-browser.enable = true;
      targets.zen-browser.profileNames = ["main"];
      targets.starship.enable = false;
      targets.fish.enable = false;
    };

    programs.zen-browser = {
      enable = true;
      setAsDefaultBrowser = true;
    };
  };
}
