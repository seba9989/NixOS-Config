{pkgs, ...}: {
  home.packages = [
    pkgs.rofi-power-menu
  ];
  programs.rofi = {
    enable = true;
    # extraConfig = {
    #   modi = "run,drun,window";
    #   icon-theme = "Oranchelo";
    #   show-icons = true;
    #   terminal = "kitty";
    #   drun-display-format = "{icon} {name}";
    #   location = 0;
    #   disable-history = false;
    #   hide-scrollbar = true;
    # };
    extraConfig = {
      display-ssh = "";
      display-run = "";
      display-drun = "";
      display-window = "";
      display-combi = "";
      show-icons = true;
    };

    theme = ./gruvbox-material.rasi;
  };
}
