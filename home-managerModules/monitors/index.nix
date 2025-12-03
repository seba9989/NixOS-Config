{
  pkgs,
  lib,
  config,
  ...
}: {
  options.monitors = lib.mkOption {
    type = lib.types.listOf (lib.types.submodule {
      options = {
        name = lib.mkOption {
          type = lib.types.str;
          example = "DP-1";
        };
        width = lib.mkOption {
          type = lib.types.int;
          example = "1920";
        };
        height = lib.mkOption {
          type = lib.types.int;
          example = "1080";
        };
        refreshRate = lib.mkOption {
          type = lib.types.int;
          example = "60";
        };
        x = lib.mkOption {
          type = lib.types.int;
          example = "0";
        };
        y = lib.mkOption {
          type = lib.types.int;
          example = "0";
        };
        scale = lib.mkOption {
          type = lib.types.int;
          example = "1";
        };
        enable = lib.mkOption {
          type = lib.types.bool;
          example = "true";
        };
      };
    });
    default = [];
  };
}
