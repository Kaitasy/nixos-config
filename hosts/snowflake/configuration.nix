{
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Berlin";

  modules = {
    core = {
      user.username = "kaitasy";

      networking = {
        enableNetworkManager = true;
        hostname = "snowflake";
      };
    };

    desktops = {
      common = {
        wallpaper = ../../wallpapers/__march_7th_and_evernight_honkai_and_1_more_drawn_by_akaguchi_35__e2c65d03baa094ce146dd92f33e563fe.jpg;
        monitors.DP-1 = {
          description = "Microstep G274QPF-QD CC2H253801114";
          resolution = "2560x1440";
          refreshRate = 165;
          cm = {
            primaries = "srgb";
            bitdepth = 10;
          };
        };
      };
      hyprland = {
        enable = true;
        anyrun.plugins.enableNixRun = true;
      };
    };
  };

  # /!\ DO NOT CHANGE /!\
  system.stateVersion = "25.11";
}
