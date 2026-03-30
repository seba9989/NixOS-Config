{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.niri = {
    pkgs,
    lib,
    ...
  }: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
    };
  };

  perSystem = {
    pkgs,
    lib,
    self',
    config,
    ...
  }: {
    packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;

      settings = let
        noctaliaExe = lib.getExe self'.packages.myNoctalia;
      in {
        spawn-at-startup = [
          (lib.getExe self'.packages.myNoctalia)
        ];

        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

        prefer-no-csd = null;
        layout = {
          gaps = 5;

          focus-ring = {
            width = 2;
            active-color = "#cba6f7";
            inactive-color = "#1e1e2e";
            urgent-color = "#f38ba8";
          };

          border = {
            width = 0;
            active-color = "#cba6f7";
            inactive-color = "#1e1e2e";
            urgent-color = "#f38ba8";
          };

          shadow = {
            color = "#11111b70";
          };

          tab-indicator = {
            active-color = "#cba6f7";
            inactive-color = "#6b02e9";
            urgent-color = "#f38ba8";
          };

          insert-hint = {
            color = "#cba6f780";
          };
        };

        layer-rule = {
          match = {
            _attrs.namespace = "^noctalia-overview*";
          };
          place-within-backdrop = true;
        };

        window-rule = {
          geometry-corner-radius = 20;
          clip-to-geometry = true;
        };

        input = {
          keyboard = {
            xkb.layout = "pl";
            numlock = true;
          };

          focus-follows-mouse = null;

          touchpad = {
            # off
            tap = null;
            # dwt
            # dwtp
            # drag false
            # drag-lock
            # natural-scroll = null;
            # accel-speed 0.2
            # accel-profile "flat"
            # scroll-factor 1.0
            # scroll-factor vertical=1.0 horizontal=-2.0
            # scroll-method "two-finger"
            # scroll-button 273
            # scroll-button-lock
            # tap-button-map "left-middle-right"
            # click-method "clickfinger"
            # left-handed
            # disabled-on-external-mouse
            # middle-emulation
          };
        };

        # outputs = {
        #   "Red Hat, Inc. QEMU Monitor Unknown" = {
        #     mode = "1920x1080@60.000";
        #     scale = 1.0;
        #   };
        # };
        # outputs =
        #   lib.mapAttrs (_name: monitor: {
        #     mode = "${toString monitor.width}x${toString monitor.height}@${toString monitor.refreshRate}";
        #     scale = monitor.scale;
        #   })
        #   config.preferences.monitors;

        cursor = {
          xcursor-theme = "breeze_cursors";
          xcursor-size = 16;
        };

        binds = let
          keys = [0 1 2 3 4 5 6 7 8 9];

          toWorkspace = key:
            if key == 0
            then "w9"
            else "w${toString (key - 1)}";

          focusBindings = builtins.listToAttrs (map (key: {
              name = "Mod+${toString key}";
              value = {focus-workspace = toWorkspace key;};
            })
            keys);

          moveBindings = builtins.listToAttrs (map (key: {
              name = "Mod+Shift+${toString key}";
              value = {move-column-to-workspace = toWorkspace key;};
            })
            keys);

          extraBindings = {
            "Mod+Return".spawn = lib.getExe pkgs.kitty;

            "Mod+Q".close-window = null;
            "Mod+F".maximize-column = null;
            "Mod+G".fullscreen-window = null;
            "Mod+Shift+F".toggle-window-floating = null;
            "Mod+C".center-column = null;
            "Mod+O" = {
              _attrs = {
                repeat = false;
              };
              toggle-overview = null;
            };

            # "Mod+S".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";
            "Mod+Left".focus-column-left = null;
            "Mod+Right".focus-column-right = null;
            "Mod+Up".focus-window-up = null;
            "Mod+Down".focus-window-down = null;

            "Mod+Shift+H".move-column-left = null;
            "Mod+Shift+L".move-column-right = null;
            "Mod+Shift+K".move-window-up = null;
            "Mod+Shift+J".move-window-down = null;

            "Mod+S".spawn-sh = "${noctaliaExe} ipc call launcher toggle";
            "Mod+V".spawn-sh = ''${pkgs.alsa-utils}/bin/amixer sset Capture toggle'';

            "XF86AudioRaiseVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+";
            "XF86AudioLowerVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-";

            "Mod+WheelScrollDown".focus-column-left = null;
            "Mod+WheelScrollUp".focus-column-right = null;
            "Mod+Ctrl+WheelScrollDown".focus-workspace-down = null;
            "Mod+Ctrl+WheelScrollUp".focus-workspace-up = null;

            "Mod+Ctrl+S".spawn-sh = ''${lib.getExe pkgs.grim} -l 0 - | ${pkgs.wl-clipboard}/bin/wl-copy'';

            "Mod+Shift+E".spawn-sh = ''${pkgs.wl-clipboard}/bin/wl-paste | ${lib.getExe pkgs.swappy} -f -'';

            "Mod+Shift+S".spawn-sh = lib.getExe (pkgs.writeShellApplication {
              name = "screenshot";
              text = ''
                ${lib.getExe pkgs.grim} -g "$(${lib.getExe pkgs.slurp} -w 0)" - \
                | ${pkgs.wl-clipboard}/bin/wl-copy
              '';
            });
          };
        in
          focusBindings
          // moveBindings
          // extraBindings;

        workspaces = let
          keys = [0 1 2 3 4 5 6 7 8 9];
        in
          builtins.listToAttrs (map (key: {
              name = "w${toString key}";
              value = {layout.gaps = 5;};
            })
            keys);

        debug = {
          honor-xdg-activation-with-invalid-serial = null;
        };
      };
    };
  };
}
