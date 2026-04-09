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
      then 10
      else key;

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
        xcursor-theme = "Banana-Catppuccin-Mocha";
        xcursor-size = 42;
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

      binds =
        workspaceBindings "focus"
        // workspaceBindings "move"
        // {
          "Mod+Return".spawn = lib.getExe pkgs.kitty;
          "Mod+S".spawn-sh = "${noctaliaExe} ipc call launcher toggle";
          "Mod+P".spawn-sh = "${noctaliaExe} ipc call sessionMenu toggle";
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
          "Mod+Up".focus-workspace-up = _: {};
          "Mod+Down".focus-workspace-down = _: {};

          "Mod+Shift+Left".move-column-left = _: {};
          "Mod+Shift+Right".move-column-right = _: {};
          "Mod+Shift+Up".move-column-to-workspace-up = _: {};
          "Mod+Shift+Down".move-column-to-workspace-down = _: {};

          "Mod+WheelScrollDown".focus-column-left = _: {};
          "Mod+WheelScrollUp".focus-column-right = _: {};
          "Mod+Ctrl+WheelScrollDown".focus-workspace-down = _: {};
          "Mod+Ctrl+WheelScrollUp".focus-workspace-up = _: {};

          "XF86AudioRaiseVolume".spawn-sh = "${noctaliaExe} ipc call volume increase";
          "XF86AudioLowerVolume".spawn-sh = "${noctaliaExe} ipc call volume decrease";
          "XF86AudioMute".spawn-sh = "${noctaliaExe} ipc call volume muteOutput";

          "XF86MonBrightnessUp".spawn-sh = "${noctaliaExe} ipc call brightness increase";
          "XF86MonBrightnessDown".spawn-sh = "${noctaliaExe} ipc call brightness decrease";

          "Mod+Ctrl+S".spawn-sh = "${lib.getExe pkgs.grim} -l 0 - | ${pkgs.wl-clipboard}/bin/wl-copy";
          "Mod+Shift+E".spawn-sh = "${pkgs.wl-clipboard}/bin/wl-paste | ${lib.getExe pkgs.swappy} -f -";
          # "Mod+Print".spawn-sh = lib.getExe (pkgs.writeShellApplication {
          #   name = "screenshot";
          #   text = ''
          #     ${lib.getExe pkgs.grim} -g "$(${lib.getExe pkgs.slurp} -w 0)" - \
          #     | ${pkgs.wl-clipboard}/bin/wl-copy
          #   '';
          # });

          "Print".screenshot = _: {};
          "Mod+Print".screenshot-window = _: {};
          "Ctrl+Shift+Print".screenshot-screen = _: {};
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
