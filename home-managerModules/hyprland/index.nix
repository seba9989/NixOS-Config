{
  pkgs,
  lib,
  config,
  ...
}: {
  options.hyprland = {
    enable = lib.mkEnableOption "Hyprland config enable";
    mainMod = lib.mkOption {
      type = lib.types.str;
      example = "SUPER";
      default = "SUPER";
    };
  };

  config = lib.mkIf config.hyprland.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        # Monitors
        monitor = map (
          m: let
            resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
            position = "${toString m.x}x${toString m.y}";
          in "${m.name}, ${
            if m.enable
            then "${resolution}, ${position}, ${toString m.scale}"
            else "disable"
          }"
        ) (config.monitors);

        # Keybindings
        bind = [
          "${config.hyprland.mainMod}, Q, exec, ${config.systemApps.terminal}"
          "${config.hyprland.mainMod}, C, killactive"
          "${config.hyprland.mainMod}, M, exit"
          "${config.hyprland.mainMod}, E, exec, ${config.systemApps.fileManager}"
          "${config.hyprland.mainMod}, V, togglefloating"
          "${config.hyprland.mainMod}, R, exec, ${config.systemApps.menu}"
          "${config.hyprland.mainMod}, P, pseudo"
          "${config.hyprland.mainMod}, J, togglesplit"

          # Move focus with mainMod + arrow keys
          "${config.hyprland.mainMod}, left, movefocus, l"
          "${config.hyprland.mainMod}, right, movefocus, r"
          "${config.hyprland.mainMod}, up, movefocus, u"
          "${config.hyprland.mainMod}, down, movefocus, d"

          # Switch workspaces with mainMod + [0–9]
          "${config.hyprland.mainMod}, 1, workspace, 1"
          "${config.hyprland.mainMod}, 2, workspace, 2"
          "${config.hyprland.mainMod}, 3, workspace, 3"
          "${config.hyprland.mainMod}, 4, workspace, 4"
          "${config.hyprland.mainMod}, 5, workspace, 5"
          "${config.hyprland.mainMod}, 6, workspace, 6"
          "${config.hyprland.mainMod}, 7, workspace, 7"
          "${config.hyprland.mainMod}, 8, workspace, 8"
          "${config.hyprland.mainMod}, 9, workspace, 9"
          "${config.hyprland.mainMod}, 0, workspace, 10"

          # Move active window with mainMod + SHIFT + [0–9]
          "${config.hyprland.mainMod} SHIFT, 1, movetoworkspace, 1"
          "${config.hyprland.mainMod} SHIFT, 2, movetoworkspace, 2"
          "${config.hyprland.mainMod} SHIFT, 3, movetoworkspace, 3"
          "${config.hyprland.mainMod} SHIFT, 4, movetoworkspace, 4"
          "${config.hyprland.mainMod} SHIFT, 5, movetoworkspace, 5"
          "${config.hyprland.mainMod} SHIFT, 6, movetoworkspace, 6"
          "${config.hyprland.mainMod} SHIFT, 7, movetoworkspace, 7"
          "${config.hyprland.mainMod} SHIFT, 8, movetoworkspace, 8"
          "${config.hyprland.mainMod} SHIFT, 9, movetoworkspace, 9"
          "${config.hyprland.mainMod} SHIFT, 0, movetoworkspace, 10"

          # Special workspace
          "${config.hyprland.mainMod}, S, togglespecialworkspace, magic"
          "${config.hyprland.mainMod} SHIFT, S, movetoworkspace, special:magic"

          # Scroll workspaces
          "${config.hyprland.mainMod}, mouse_down, workspace, e+1"
          "${config.hyprland.mainMod}, mouse_up, workspace, e-1"
        ];

        bindm = [
          "${config.hyprland.mainMod}, mouse:272, movewindow"
          "${config.hyprland.mainMod}, mouse:273, resizewindow"
        ];

        bindel = [
          ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ", XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
          ", XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
        ];

        bindl = [
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPause, exec, playerctl play-pause"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioPrev, exec, playerctl previous"
        ];

        ###################
        ### LOOK & FEEL ###
        ###################

        general = {
          gaps_in = 5;
          gaps_out = 20;
          border_size = 2;
          "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";
          resize_on_border = false;
          allow_tearing = false;
          layout = "dwindle";
        };

        decoration = {
          rounding = 10;
          rounding_power = 2;
          active_opacity = 1.0;
          inactive_opacity = 1.0;

          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            color = "rgba(1a1a1aee)";
          };

          blur = {
            enabled = true;
            size = 3;
            passes = 1;
            vibrancy = 0.1696;
          };
        };

        animations = {
          enabled = "yes, please :)";

          bezier = [
            "easeOutQuint,   0.23, 1,    0.32, 1"
            "easeInOutCubic, 0.65, 0.05, 0.36, 1"
            "linear,         0,    0,    1,    1"
            "almostLinear,   0.5,  0.5,  0.75, 1"
            "quick,          0.15, 0,    0.1,  1"
          ];

          animation = [
            "global,        1, 10,   default"
            "border,        1, 5.39, easeOutQuint"
            "windows,       1, 4.79, easeOutQuint"
            "windowsIn,     1, 4.1,  easeOutQuint, popin 87%"
            "windowsOut,    1, 1.49, linear,       popin 87%"
            "fadeIn,        1, 1.73, almostLinear"
            "fadeOut,       1, 1.46, almostLinear"
            "fade,          1, 3.03, quick"
            "layers,        1, 3.81, easeOutQuint"
            "layersIn,      1, 4,    easeOutQuint, fade"
            "layersOut,     1, 1.5,  linear,       fade"
            "fadeLayersIn,  1, 1.79, almostLinear"
            "fadeLayersOut, 1, 1.39, almostLinear"
            "workspaces,    1, 1.94, almostLinear, fade"
            "workspacesIn,  1, 1.21, almostLinear, fade"
            "workspacesOut, 1, 1.94, almostLinear, fade"
            "zoomFactor,    1, 7,    quick"
          ];
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        master = {
          new_status = "master";
        };

        misc = {
          force_default_wallpaper = -1;
          disable_hyprland_logo = false;
        };

        #################
        ### INPUT ######
        #################

        input = {
          kb_layout = "pl";
          kb_variant = "";
          kb_model = "";
          kb_options = "terminate:ctrl_alt_bksp";
          kb_rules = "";
          follow_mouse = 1;
          sensitivity = 0;

          touchpad.natural_scroll = false;
        };

        # Gestures
        gesture = "3, horizontal, workspace";

        # Per-device config
        device = [
          {
            name = "epic-mouse-v1";
            sensitivity = -0.5;
          }
        ];
      };
    };
  };
}
