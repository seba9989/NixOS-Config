{...}: {
  flake.homeModules.cursor = {pkgs, ...}: {
    home.pointerCursor = let
      getFrom = url: hash: name: {
        name = name;
        package = pkgs.runCommand "moveUp" {} ''
          mkdir -p $out/share/icons
          ln -s ${pkgs.fetchzip {
            url = url;
            hash = hash;
          }} $out/share/icons/${name}
        '';
      };
    in
      getFrom
      "https://github.com/dreamsofautonomy/banana-cursor/releases/download/v2.2.0/Banana-Catppuccin-Mocha.tar.xz"
      "sha256-PaN4NLB/qZXW7kUfR+cpCUNSOBRZyM3jTUnO3QEkwdw="
      "Banana-Catppuccin-Mocha";
  };
}
