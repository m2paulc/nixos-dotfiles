# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot = {
    enable = true;
    consoleMode = "0";
  };
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "mynixos-btw"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Load the proprietary nvidia drivers to services and other options
  # services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver = {
    videoDrivers = [ "nvidia" ];
    upscaleDefaultCursor = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  hardware.nvidia = {
    # Modesetting is definitely required for wayland
    modesetting.enable = true;

    # Nvidia power management
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    # Use the proprietary open-source drivers
    # (false for older cards, true for newer rtx cards)
    open = false;

    # Enable nvidia settings menu
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };  

  # Environment variables to force Wayland to use nvidia
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NIXOS_OZONE_WL = "1";
  };

  environment.variables.GDK_SCALE = "1";

  # Enable hardware graphics
  hardware.graphics.enable = true;

  # Enable Logitech Wireless
  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };

  # Enable Polkit
  security.polkit.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # Recommended for screen sharing and Flatpaks
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # auto login getty
  services.getty.autologinUser = "paul";

  # enable hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.paul = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    kitty
    wofi
    waybar
    hyprpaper
    fish
    solaar
  ];

  # enable flakes
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Allow unfree for nvidia
  nixpkgs.config.allowUnfree = true;

  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}

