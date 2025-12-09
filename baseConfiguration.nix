{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./nixosModules/index.nix
  ];

  # Enable networking
  networking.networkmanager.enable = lib.mkDefault true;
  # networking.wireless.enable = lib.mkDefault true; # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # Select internationalisation properties.
  i18n.defaultLocale = "pl_PL.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "pl";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "pl2";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/seba9989/.config/NixOS-Config/";
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.seba9989 = {
    isNormalUser = true;
    description = "Seba9989";
    extraGroups = ["networkmanager" "wheel"];

    shell = pkgs.fish;
  };

  programs.fish = {
    enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  home-manager = {
    useGlobalPkgs = true;
    # useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs;
      osConfig = config;
    };
    users = {
      seba9989 = import ./users/seba9989/home.nix;
    };
    backupFileExtension = "backup";
  };

  environment.systemPackages = [
    pkgs.git
    pkgs.gh
    pkgs.jujutsu
    inputs.alejandra.defaultPackage.x86_64-linux
  ];

  system.stateVersion = "26.05";
}
