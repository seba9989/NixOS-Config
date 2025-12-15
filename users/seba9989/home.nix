{
  pkgs,
  inputs,
  lib,
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
    targets.starship.enable = false;
    targets.fish.enable = false;
  };

  catppuccin = {
    enable = true;
  };

  # gtk = {
  #   enable = true;
  #   iconTheme = {
  #     name = "Papirus-Dark";
  #     package = pkgs.catppuccin-papirus-folders.override {
  #       flavor = "mocha";
  #       accent = "mauve";
  #     };
  #   };
  # };

  home.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.meslo-lg
    nerd-fonts.jetbrains-mono

    vscode
    nodejs
    bun
    podman-desktop
    podman-compose

    nixd
    rofi
    rofi-power-menu

    nemo-with-extensions

    vesktop

    httpie-desktop
    gitkraken
    brave
    faugus-launcher
    pavucontrol
    devenv
    typstyle
    tinymist
    opencode
    uv
    jetbrains.clion
    gcc
    cmake
    thunderbird
    bruno

    freecad

    distrobox
  ];

  programs.kitty.enable = true;
  programs.starship.enable = true;

  dconf = {
    settings = {
      "org/cinnamon/desktop/applications/terminal" = {
        exec = "kitty";
        # exec-arg = ""; # argument
      };
    };
  };

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
    EDITOR = "micro";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
