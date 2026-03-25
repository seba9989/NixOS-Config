{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.DesktopConfiguration = {
    pkgs,
    lib,
    ...
  }: {
    # import any other modules from here
    imports = [
      self.nixosModules.DesktopHardware
      # self.nixosModules.niri
    ];

    nix.settings.experimental-features = ["nix-command" "flakes"];

    users.users.seba9989 = {
      isNormalUser = true;
      description = "Seba9989";
      extraGroups = ["networkmanager" "wheel"];
      packages = with pkgs; [
        #  thunderbird
      ];
    };

    nixpkgs.config.allowUnfree = true;
    environment.systemPackages = with pkgs; [
      firefox
      vscode
      nixd
      alejandra
      jujutsu
    ];

    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/seba9989/.config/NixOS-Config"; # sets NH_OS_FLAKE variable for you
    };

    # ...

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the GNOME Desktop Environment.
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;

    system.stateVersion = "26.05";
  };
}
