# { inputs, ... }:
# {
#   flake.homeModules.zed =
#     { pkgs, lib, ... }:
#     {
#       catppuccin.zed.enable = false;
#       programs.zed-editor = {
#         enable = true;
#         extensions = [
#           "catppuccin"
#           "material-icon-theme"
#         ];
#         userSettings = lib.mapAttrs (_: lib.mkForce) (
#           builtins.fromJSON (builtins.readFile ./settings.json)
#         );
#       };
#     };
# }
{inputs, ...}: {
  flake.homeModules.zed = {
    pkgs,
    lib,
    ...
  }: let
    jj-lsp = pkgs.rustPlatform.buildRustPackage {
      pname = "jj-lsp";
      version = "unstable-2026-07-14";

      src = pkgs.fetchFromGitHub {
        owner = "nilskch";
        repo = "jj-lsp";
        rev = "main"; # najlepiej wstaw konkretny commit sha
        hash = "sha256-QjJXMZKu5RXkqV4MtY5JtyWjHvapFmZjmo+vIDONQmI=";
      };

      cargoHash = "sha256-k6SmlzXD/pulZV50tSJEcQ/Cj8Ogs/xve75GCM6dTiE="; # jw., poda prawdziwy w kolejnym kroku

      meta = {
        description = "LSP to resolve conflicts in the jj-vcs";
        homepage = "https://github.com/nilskch/jj-lsp";
      };
    };
  in {
    catppuccin.zed.enable = false;
    programs.zed-editor = {
      enable = true;
      extensions = [
        "catppuccin"
        "material-icon-theme"
      ];
      userSettings = lib.mapAttrs (_: lib.mkForce) (
        builtins.fromJSON (builtins.readFile ./settings.json)
      );
    };

    home.packages = [jj-lsp];
  };
}
