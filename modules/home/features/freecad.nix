{ ... }:
{
  flake.homeModules.freecad =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        freecad
      ];
    };
}
