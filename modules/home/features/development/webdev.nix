{inputs, ...}: {
  flake.homeModules.webdev = {pkgs, ...}: {
    home.packages = with pkgs; [
      bun
      nodejs
    ];
  };
}
