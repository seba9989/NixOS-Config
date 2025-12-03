{lib, ...}: {
  options.systemApps = lib.mkOption {
    type = lib.types.submodule {
      options = {
        terminal = lib.mkOption {
          type = lib.types.str;
          example = "kitty";
        };
        fileManager = lib.mkOption {
          type = lib.types.str;
          example = "nemo";
        };
        menu = lib.mkOption {
          type = lib.types.str;
          example = "rofi -show drun";
        };
      };
    };
    default = {
      terminal = "kitty";
      fileManager = "nemo";
      menu = "rofi -show drun";
    };
  };
}
