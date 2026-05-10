{ inputs, ... }:
{
  flake.homeModules.zed =
    { pkgs, lib, ... }:
    let
      settingsJson = pkgs.runCommand "zed-settings.json" { } ''
        ${pkgs.hjson}/bin/hjson -j ${./settings.json} > $out
      '';
    in
    {
      catppuccin.zed.enable = false;

      programs.zed-editor = {
        enable = true;

        extensions = [
          "catppuccin"
          "material-icon-theme"
        ];

        userSettings = lib.mapAttrs (_: lib.mkForce) (builtins.fromJSON (builtins.readFile settingsJson));
      };
    };
}
