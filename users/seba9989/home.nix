{
  pkgs,
  inputs,
  ...
}: {
  home.username = "seba9989";
  home.homeDirectory = "/home/seba9989";

  home.stateVersion = "25.11"; # Please read the comment before changing.

  imports = [
    inputs.stylix.homeModules.stylix
    inputs.zen-browser.homeModules.beta
    ../../home-managerModules/index.nix
  ];

  programs.zen-browser = {
    enable = true;

    profiles = {
      main = {
      };
    };
  };

  programs.rofi.enable = true;

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

    targets.zen-browser.profileNames = ["main"];
  };

  home.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.meslo-lg
    nerd-fonts.jetbrains-mono

    vscode
    nixd
    kitty
    rofi
    git
    gh
    jujutsu
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
