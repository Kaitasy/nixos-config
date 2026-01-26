{
  self',
  config,
  lib,
  ...
}: {
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Berlin";

  # Gonna need this sooner or later
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

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
        mainModKey = "ALT";
        anyrun.plugins.enableNixRun = true;

        settings.bind = [
          ", PRINT, exec, ${lib.getExe self'.packages.screenshot}"
          "CTRL, F2, exec, ${lib.getExe self'.packages.gsr-replay-save}"
        ];
      };
    };

    programs = {
      utility = {
        kitty.enable = true;
      };
    };

    services = {
      user.gsr-replay = {
        enable = true;

        video = {
          source = "DP-1";
          codec = "av1_10bit";
        };

        audio = {
          sources = [
            "app-inverse:mpd.PipeWire Output|app-inverse:Zen" # Everything except mpd and zen
            "app:mpd.PipeWire Output|app:Zen" # mpd and zen
            "default_input"
          ];
          bitrate = 320;
        };

        replay.outputDirectory = config.hj.directory + "/Videos";
      };
    };
  };

  # /!\ DO NOT CHANGE /!\
  system.stateVersion = "25.11";
}
