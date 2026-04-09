{
  flake.nixosModules.base =
    { pkgs, ... }:
    {
      nixpkgs.config.allowUnfree = true;
      environment.systemPackages = with pkgs; [
        firefox
        vscode
        nixd
        nil
        alejandra
        jujutsu

        git
        gh
      ];

      programs.nix-ld = {
        enable = true;
        libraries = pkgs.steam-run.args.multiPkgs pkgs;
      };

      programs.nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--keep-since 4d --keep 3";
        flake = "/home/seba9989/.config/NixOS-Config"; # sets NH_OS_FLAKE variable for you
      };

      system.stateVersion = "26.05";
    };
}
