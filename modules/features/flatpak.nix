{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.flatpak = {
    pkgs,
    lib,
    config,
    ...
  }: {
    services.flatpak = {
      enable = true;

      overrides = {
        global = {
          Context.filesystems = ["/nix/store:ro"];
        };
      };
    };
  };
}
