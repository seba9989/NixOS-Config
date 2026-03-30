{inputs, ...}: {
  flake.homeModules.catppuccin = {...}: {
    imports = [
      inputs.catppuccin.homeModules.catppuccin    ];

    catppuccin.enable = true;
  };
}
