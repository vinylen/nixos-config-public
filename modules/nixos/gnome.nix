{pkgs, ...}: {
  environment = {
    systemPackages = with pkgs; [
      gnomeExtensions.appindicator
      gnomeExtensions.dash-to-dock
      gnomeExtensions.logo-menu
      gnomeExtensions.wireless-hid
      gnomeExtensions.vitals
    ];
  };
  services = {
    fwupd.enable = true;
    hardware.bolt.enable = true;
    fstrim.enable = true;
    gvfs.enable = true;

    smartd = {
      enable = true;
      autodetect = true;
    };

    # Enable libinput.
    libinput = {
      enable = true;
      touchpad = {
        disableWhileTyping = true;
        naturalScrolling = false;
      };
    };
    dbus.enable = true;
  };
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = true;

    extraPortals = [
      # pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
    ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
    ];
  };
  # Unable to get this to work
  # programs.dconf = {
  #   enable = true;
  #   profiles = {
  #     # A "user" profile with a database
  #     user.databases = [
  #       {
  #         lockAll = true;
  #         settings = {
  #           "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
  #             binding = "<Super>Return";
  #             command = "/home/vicnil/.nix-profile/bin/foot";
  #             name = "Foot terminal";
  #           };
  #         };
  #       }
  #     ];
  #   };
  # };
}
