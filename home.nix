  { config, pkgs, ... }:

  {
    home.username = "paul";
    home.homeDirectory = "/home/paul";
    home.stateVersion = "25.11";
    programs.bash = {
      enable = true;
      shellAliases = {
        btw = "echo this is NixOS with Hyprland btw";
      };
      profileExtra = ''
        if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
           exec start-hyprland
        fi
     '';
    };
    home.file.".config/hypr".source = ./config/hypr;
    home.file.".config/waybar".source = ./config/waybar;

    home.packages = with pkgs; [
      font-awesome
    ];
    fonts.fontconfig.enable = true;
  }
