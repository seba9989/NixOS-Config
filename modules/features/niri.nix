{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.niri = {
    pkgs,
    lib,
    config,
    ...
  }: let
    self' = self.packages.${pkgs.stdenv.hostPlatform.system};
    noctaliaExe = lib.getExe self'.myNoctalia;

    keys = [0 1 2 3 4 5 6 7 8 9];
    toWorkspace = key:
      if key == 0
      then "w9"
      else "w${toString (key - 1)}";

    workspaceBindings = type:
      builtins.listToAttrs (map (key: {
          name = "Mod+${
            if type == "move"
            then "Shift+"
            else ""
          }${toString key}";
          value =
            if type == "move"
            then {move-column-to-workspace = toWorkspace key;}
            else {focus-workspace = toWorkspace key;};
        })
        keys);

    niriSettings = {
      spawn-at-startup = [noctaliaExe];

      xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
      prefer-no-csd = _: {};

      outputs =
        builtins.trace "monitors = ${builtins.toJSON config.preferences.monitors}"
        lib.mapAttrs (
          _: m:
            {
              mode = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
              scale = m.scale;
              position = _: {
                props = {
                  x = m.x;
                  y = m.y;
                };
              };
            }
            // lib.optionalAttrs (m.VRR.enable == true) {
              variable-refresh-rate =
                if m.VRR.onDemand
                then _: {props.on-demand = true;}
                else _: {};
            }
            // lib.optionalAttrs (m.primary == true) {
              focus-at-startup = _: {};
            }
            // {
              hot-corners = {
                top-left = _: {};
              };
            }
        )
        config.preferences.monitors;

      cursor = {
        xcursor-theme = "breeze_cursors";
        xcursor-size = 16;
      };

      input = {
        keyboard = {
          xkb.layout = "pl";
          numlock = true;
        };
        focus-follows-mouse = _: {};
        touchpad.tap = _: {};
      };

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
        shadow.color = "#11111b70";
        tab-indicator = {
          active-color = "#cba6f7";
          inactive-color = "#6b02e9";
          urgent-color = "#f38ba8";
        };
        insert-hint.color = "#cba6f780";
      };

      layer-rule = {
        match = _: {props.namespace = "^noctalia-overview*";};
        place-within-backdrop = true;
      };

      window-rule = {
        geometry-corner-radius = 20;
        clip-to-geometry = true;
      };

      workspaces = builtins.listToAttrs (map (key: {
          name = "w${toString key}";
          value = {layout.gaps = 5;};
        })
        keys);

      binds =
        workspaceBindings "focus"
        // workspaceBindings "move"
        // {
          "Mod+Return".spawn = lib.getExe pkgs.kitty;
          "Mod+S".spawn-sh = "${noctaliaExe} ipc call launcher toggle";
          "Mod+V".spawn-sh = "${pkgs.alsa-utils}/bin/amixer sset Capture toggle";

          "Mod+Q".close-window = _: {};
          "Mod+F".maximize-column = _: {};
          "Mod+G".fullscreen-window = _: {};
          "Mod+C".center-column = _: {};
          "Mod+Shift+F".toggle-window-floating = _: {};
          "Mod+O" = _: {
            props.repeat = false;
            content.toggle-overview = _: {};
          };

          "Mod+Left".focus-column-left = _: {};
          "Mod+Right".focus-column-right = _: {};
          "Mod+Up".focus-window-up = _: {};
          "Mod+Down".focus-window-down = _: {};
          "Mod+Shift+Left".move-column-left = _: {};
          "Mod+Shift+Right".move-column-right = _: {};
          "Mod+Shift+Up".move-window-up = _: {};
          "Mod+Shift+Down".move-window-down = _: {};

          "Mod+WheelScrollDown".focus-column-left = _: {};
          "Mod+WheelScrollUp".focus-column-right = _: {};
          "Mod+Ctrl+WheelScrollDown".focus-workspace-down = _: {};
          "Mod+Ctrl+WheelScrollUp".focus-workspace-up = _: {};

          "XF86AudioRaiseVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+";
          "XF86AudioLowerVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-";

          "Mod+Ctrl+S".spawn-sh = "${lib.getExe pkgs.grim} -l 0 - | ${pkgs.wl-clipboard}/bin/wl-copy";
          "Mod+Shift+E".spawn-sh = "${pkgs.wl-clipboard}/bin/wl-paste | ${lib.getExe pkgs.swappy} -f -";
          "Mod+Shift+S".spawn-sh = lib.getExe (pkgs.writeShellApplication {
            name = "screenshot";
            text = ''
              ${lib.getExe pkgs.grim} -g "$(${lib.getExe pkgs.slurp} -w 0)" - \
              | ${pkgs.wl-clipboard}/bin/wl-copy
            '';
          });
        };

      debug.honor-xdg-activation-with-invalid-serial = _: {};
    };
  in {
    services.desktopManager.gnome.enable = true;
    services.displayManager.ly.enable = true;

    programs.niri = let
      pkg = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;

        settings = niriSettings;
      };
    in {
      enable = true;
      package = builtins.trace "niri config: ${pkg}/niri-config.kdl" pkg;
    };
  };
}
