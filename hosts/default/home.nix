{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../../homeManagerModules/default.nix
    # ../../homeManagerModules/desktop/waybar/default.nix
  ];

  nixpkgs.overlays = [
    inputs.nix-vscode-extensions.overlays.default
  ];

  vscode.enable = true;
  hyprland.enable = true;

  monitors = [
    {
      name = "DP-2";
      width = 1920;
      height = 1080;
      refreshRate = 165;
      x = 1920;
      y = 0;
    }
    {
      name = "HDMI-A-1";
      width = 1920;
      height = 1080;
      refreshRate = 75;
      x = 0;
      y = 0;
    }
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "seba9989";
  home.homeDirectory = "/home/seba9989";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  gtk.enable = true;

  # home.file = {
  #   ".local/share/icons/GruvboxPlus".source = "${pkgs.gruvbox-plus-icons}/share/icons/Gruvbox-Plus-Dark";
  # };

  programs = {
    btop.enable = true;
    kitty.enable = true;
    fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
      '';
      plugins = [
        {
          name = "grc";
          src = pkgs.fishPlugins.grc.src;
        }
      ];
    };
    micro.enable = true;
    firefox.enable = true;
    firefox.profiles = {
      default = {
        extensions.force = true;
      };
    };
    starship.enable = true;

    # partition-manager.enable = true;
  };
  # gtk.enable = true;
  # programs.fish.enable = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    kitty
    micro
    yazi
    waybar
    kdePackages.partitionmanager
    gparted
    vesktop

    # vscode

    nemo
    alejandra
    hyprpolkitagent

    neovim
    zig
    zed-editor
    gitkraken

    firefox
    bat
    grc
    pavucontrol
    git
  ];

  services.udiskie = {
    enable = true;
    settings = {
      # workaround for
      # https://github.com/nix-community/home-manager/issues/632
      program_options = {
        # replace with your favorite file manager
        file_manager = "${pkgs.nemo-with-extensions}/bin/nemo";
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

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/seba9989/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "micro";
    NH_FLAKE = "/etc/nixos/";
    NIXOS_OZONE_WL = 1;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
