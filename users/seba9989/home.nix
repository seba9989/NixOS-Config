{pkgs, ...}: {
  home.username = "seba9989";
  home.homeDirectory = "/home/seba9989";

  home.stateVersion = "25.11"; # Please read the comment before changing.

  imports = [
    ../../home-managerModules/index.nix
  ];

  monitors = [
    {
      name = "Virtual-1";
      width = 1920;
      height = 1200;
      refreshRate = 60;
      x = 0;
      y = 0;
      scale = 1;
      enable = true;
    }
  ];

  hyprland.enable = true;

  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
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
