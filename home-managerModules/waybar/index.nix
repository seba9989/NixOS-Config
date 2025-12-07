{
  lib,
  config,
  ...
}: {
  options.waybar = {
    enable = lib.mkEnableOption "Waybar config enable";
    autostart = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkIf config.waybar.enable {
    programs.waybar = {
      enable = true;
      style = builtins.concatStringsSep "\n" [
        (builtins.readFile ./mocha.css)
        (builtins.readFile ./style.css)
      ];
      settings = {
        mainBar = {
          position = "top";

          modules-left = ["hyprland/workspaces"];
          modules-center = ["hyprland/window"];
          modules-right = [
            "tray"
            "memory"
            "pulseaudio"
            "battery"
            "clock"
            "custom/power"
          ];

          tray = {
            "icon-size" = 15;
            spacing = 5;
          };

          clock = {
            format = "<span>   </span>{:%a %d %H:%M}";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          };

          battery = {
            states = {
              warning = 30;
              critical = 15;
            };
            format = "<span size='13000' foreground='#a6e3a1'>{icon} </span> {capacity}%";
            format-warning = "<span size='13000' foreground='#B1E3AD'>{icon} </span> {capacity}%";
            format-critical = "<span size='13000' foreground='#E38C8F'>{icon} </span> {capacity}%";
            format-charging = "<span size='13000' foreground='#B1E3AD'> </span>{capacity}%";
            format-plugged = "<span size='13000' foreground='#B1E3AD'> </span>{capacity}%";
            format-alt = "<span size='13000' foreground='#B1E3AD'>{icon} </span> {time}";
            format-full = "<span size='13000' foreground='#B1E3AD'> </span>{capacity}%";
            format-icons = ["" "" "" "" ""];
            tooltip-format = "{time}";
          };

          memory = {
            interval = 30;
            format = "  {used:0.2f} / {total:0.0f} GB";
            on-click = "${config.systemApps.terminal} -e btop";
          };

          pulseaudio = {
            format = "{icon}  {volume}%";
            format-muted = "";
            format-icons = {
              default = ["" "" " "];
            };
            on-click = "pavucontrol";
          };

          "custom/power" = {
            format = " 󰐥 ";
            tooltip = false;
            on-click = "wlogout";
          };
        };
      };
    };
  };
}
