{...}: {
  programs.waybar = {
    enable = true;

    style = builtins.readFile ./style.css;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;

        modules-left = [
          "hyprland/workspaces"
        ];
        modules-center = [
          "hyprland/window"
        ];
        modules-right = [
          "tray"
          "memory"
          "pulseaudio"
          "clock"
        ];

        tray = {
          icon-size = 15;
          spacing = 5;
        };
        memory = {
          interval = 30;
          format = " {used:0.2f}/{total:0.0f} GB";
        };
        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "";
          format-icons = {
            default = ["" "" " "];
          };
          on-click = "pavucontrol";
        };
        clock = {
          format = " {:%a %d %H:%M}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };
      };
    };
  };
}
