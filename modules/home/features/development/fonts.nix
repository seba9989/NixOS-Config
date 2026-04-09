{inputs, ...}: {
  flake.homeModules.fonts = {pkgs, ...}: {
    home.packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.meslo-lg
      nerd-fonts.jetbrains-mono
    ];
  };
}
