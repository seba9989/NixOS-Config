{
  flake.nixosModules.base = {...}: {
    nix.settings.experimental-features = ["nix-command" "flakes"];
  };
}
