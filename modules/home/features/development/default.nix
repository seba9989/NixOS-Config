{ self, ... }:
{
  flake.homeModules.DevelopmentDefault =
    { ... }:
    {
      imports = [
        self.homeModules.webdev
        self.homeModules.fonts
        self.homeModules.zed
      ];
    };
}
