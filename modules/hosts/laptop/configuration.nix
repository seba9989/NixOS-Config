{self, ...}: {
  flake.nixosModules.LaptopConfiguration = {pkgs, ...}: {
    networking.hostName = "Laptop";
    # import any other modules from here
    imports = [
      self.nixosModules.LaptopHardware
      self.nixosModules.base
      self.nixosModules.niri
    ];

    preferences.monitors = {
      "DP-2" = {
        primary = true;
        width = 1920;
        height = 1080;
        refreshRate = 165;
        x = 0;
        y = 0;

        VRR = {
          enable = true;
          onDemand = false;
        };
      };
    };

    nix.settings.experimental-features = ["nix-command" "flakes"];

    users.users.seba9989 = {
      isNormalUser = true;
      description = "Seba9989";
      extraGroups = ["networkmanager" "wheel"];

      shell = pkgs.fish;
    };

    nixpkgs.config.allowUnfree = true;
    environment.systemPackages = with pkgs; [
      firefox
      vscode
      nixd
      alejandra
      jujutsu
      git
      gh
    ];

    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/seba9989/.config/NixOS-Config"; # sets NH_OS_FLAKE variable for you
    };

    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting
      '';
    };

    # ...

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the GNOME Desktop Environment.
    # services.displayManager.gdm.enable = true;
    services.displayManager.enable = true;
    systemd.services.lidm.enable = true;
    services.desktopManager.gnome.enable = true;

    system.stateVersion = "26.05";
  };
}
