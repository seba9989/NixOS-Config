{
  lib,
  config,
  ...
}: {
  options = {
    hyprland.enable = lib.mkEnableOption "enables hyprland";
  };

  config = lib.mkIf config.hyprland.enable {
    home.sessionVariables = {
      HYPRCURSOR_THEME = "${config.stylix.cursor.name}";
      HYPRCURSOR_SIZE = "${toString config.stylix.cursor.size}";
    };

    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        "$mod" = "SUPER";
        "$terminal" = "kitty";
        "$fileManager" = "nemo";
        "$menu" = "rofi -show drun";
        "$power" = "rofi -show power-menu -modi power-menu:rofi-power-menu -theme-str 'element-icon {size: 0;}'";

        exec-once = [
          "systemctl --user start hyprpolkitagent"
          "hyprctl setcursor ${config.stylix.cursor.name} ${toString config.stylix.cursor.size}"
          "waybar"
        ];

        monitor = map (
          m: let
            resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
            position = "${toString m.x}x${toString m.y}";
          in "${m.name}, ${
            if m.enable
            then "${resolution}, ${position}, 1"
            else "disable"
          }"
        ) (config.monitors);

        input = {
          kb_layout = "pl";
        };

        bind =
          [
            "$mod, Q, exec, kitty"
            "$mod, C, killactive"
            "$mod, M, exit"
            "$mod, E, exec, $fileManager"
            "$mod, V, togglefloating"
            "$mod, R, exec, $menu"
            "$mod, T, exec, $power"
            "$mod, P, pseudo"
            "$mod, J, togglesplit"

            # Move focus with mainMod + arrow keys
            "$mod, left, movefocus, l"
            "$mod, right, movefocus, r"
            "$mod, up, movefocus, u"
            "$mod, down, movefocus, d"

            # Scroll through existing workspaces with mainMod + scroll
            "$mod, mouse_down, workspace, e+1"
            "$mod, mouse_up, workspace, e-1"
          ]
          ++ (
            # workspaces
            # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
            builtins.concatLists (builtins.genList (
                i: let
                  ws = i + 1;
                in [
                  "$mod, code:1${toString i}, workspace, ${toString ws}"
                  "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
                ]
              )
              9)
          );

        bindm = [
          # Move/resize windows with mainMod + LMB/RMB and dragging
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];

        bindel = [
          # Laptop multimedia keys for volume and LCD brightness
          ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
          ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
        ];

        bindl = [
          # Requires playerctl
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPause, exec, playerctl play-pause"
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioPrev, exec, playerctl previous"
        ];

        general = {
          border_size = 2;
        };

        decoration = {
          rounding = 10;
          rounding_power = 2;
        };

        misc = {
          disable_hyprland_logo = true;
        };

        windowrule = [
          "suppressevent maximize, class:.*"
          "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"

          # pavucontrol
          "float, class:org.pulseaudio.pavucontrol"
          "size 50% 50%, class:org.pulseaudio.pavucontrol"
        ];
      };
    };
  };
}
