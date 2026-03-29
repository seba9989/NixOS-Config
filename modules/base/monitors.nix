{
  flake.nixosModules.base = {lib, ...}: {
    options.preferences.monitors = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          primary = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
          width = lib.mkOption {
            type = lib.types.int;
            example = 1920;
          };
          height = lib.mkOption {
            type = lib.types.int;
            example = 1080;
          };
          refreshRate = lib.mkOption {
            type = lib.types.float;
            default = 60;
          };
          x = lib.mkOption {
            type = lib.types.int;
            default = 0;
          };
          y = lib.mkOption {
            type = lib.types.int;
            default = 0;
          };
          enabled = lib.mkOption {
            type = lib.types.bool;
            default = true;
          };

          scale = lib.mkOption {
            type = lib.types.float;
            default = 1.0;
          };
          VRR = lib.mkOption {
            type = lib.types.submodule {
              options = {
                enable = lib.mkOption {
                  type = lib.types.bool;
                  default = true;
                };
                onDemand = lib.mkOption {
                  type = lib.types.bool;
                  default = false;
                };
              };
            };
            default = {};
          };
        };
      });
      default = {};
    };
  };
}
