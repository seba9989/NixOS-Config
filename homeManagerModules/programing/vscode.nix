{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    vscode.enable = lib.mkEnableOption "enables vscode";
  };

  config = lib.mkIf config.vscode.enable {
    programs.vscode = {
      enable = true;
      #mutableExtensionsDir = false;

      profiles.default = {
        # extensions = with pkgs.vscode-marketplace; [
        #   # dracula-theme.theme-dracula
        #   # steam
        # ];

        userSettings = {
          "workbench.iconTheme" = "a-file-icon-vscode";

          "editor.formatOnSave" = true;

          "nix.serverPath" = "nixd";
          "nix.enableLanguageServer" = true;
          "nix.serverSettings" = {
            "nixd" = {
              "nixpkgs" = {
                "expr" = "import (builtins.getFlake \"/etc/nixos/\").inputs.nixpkgs { }";
              };
              "formatting" = {
                "command" = ["alejandra"];
              };
              "options" = {
                "nixos" = {
                  "expr" = "(builtins.getFlake \"/etc/nixos/\").nixosConfigurations.nixos.options";
                };
              };
              # "home-manager" = {
              #   "expr"
              # };
            };
          };
        };
      };
    };
  };
}
