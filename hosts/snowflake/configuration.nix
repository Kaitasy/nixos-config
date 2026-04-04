{
  pkgs,
  self',
  lib,
  ...
}: {
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Berlin";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    amdgpu.initrd.enable = true;
    new-lg4ff.enable = true;
    wooting.enable = true;
  };

  fileSystems = {
    "/mnt/big_bulk" = {
      device = "/dev/disk/by-uuid/0b461315-db7e-4ecd-94c9-fe7df1fd405a";
      options = ["nofail"];
    };

    "/mnt/little_bulk" = {
      device = "/dev/disk/by-uuid/0a6f9446-fcb8-4da7-ad78-0f4b04b07f77";
      options = ["nofail"];
    };

    "/mnt/ssd" = {
      device = "/dev/disk/by-uuid/70641405-70a7-4062-b2c6-21eca8dc654a";
      options = ["nofail"];
    };
  };

  users.users = {
    sonarr.extraGroups = ["starlm"];
    radarr.extraGroups = ["starlm"];
  };

  modules = {
    core = {
      user.username = "starlm";

      networking = {
        enableNetworkManager = true;
        hostname = "snowflake";
      };

      tuigreet = {
        enable = true;
        defaultCommand = "start-hyprland";
      };
    };

    hardware = {
      wlmouse.enableUdevRules = true;
    };

    desktops = {
      common = {
        wallpaper = ../../wallpapers/1772566504527467.jpg;
        monitors = {
          DP-1 = {
            description = "Microstep G274QPF-QD CC2H253801114";
            resolution = "2560x1440";
            refreshRate = 165;
            cm = {
              primaries = "srgb";
              bitdepth = 10;
            };
          };
        };
        input.sensitivity = -0.7;
      };
      hyprland = {
        enable = true;
        useGit = true;
        mainModKey = "SUPER";
        hypridle = {
          enable = true;
          screenSleepDelay = 180;
        };

        settings = {
          bind = [
            ", PRINT, exec, ${lib.getExe self'.packages.screenshot} region"
            "CTRL, PRINT, exec, ${lib.getExe self'.packages.screenshot} monitor"
            "CTRL, F2, exec, ${lib.getExe self'.packages.gsr-replay-save}"
            "$mainMod CTRL, 1, movecurrentworkspacetomonitor, DP-1"
            "$mainMod CTRL, 2, movecurrentworkspacetomonitor, HDMI-A-1"
          ];
          workspace = [
            "1, monitor:HDMI-A-1, default:true"
            "r[2-9], monitor:DP-1, default:true"
          ];
        };
      };
      niri = {
        enable = false;
        useWipBranch = true;
        binds = [
          "Ctrl+F2 { spawn \"${lib.getExe self'.packages.gsr-replay-save}\"; }"
        ];
      };
    };

    programs = {
      development = {
        neovim.enable = true;
        git.enable = true;
      };

      social = {
        fluffychat.enable = true;
        discord.enable = true;
      };

      gaming = {
        steam.enable = true;
        bs-manager.enable = true;
        mangohud.enable = true;
        prismlauncher.enable = true;
        gamescope.enable = true;
        gamemode.enable = true;
        trucky.enable = true;
      };

      media = {
        mpv.enable = true;
        feishin.enable = true;
      };

      utility = {
        kitty.enable = true;
        playerctl.enable = true;
        pwvucontrol.enable = true;
        btop.enable = true;
        dolphin.enable = true;
        walker.enable = true;
      };

      web = {
        librewolf.enable = true;
        #qbittorrent.enable = true;
        surge.enable = true;
      };

      vr.wivrn.enable = true;

      flatpak = {
        enable = true;

        creativity.kdenlive = true;

        utility = {
          bottles = true;
          gradia = true;
        };
      };
    };

    services = {
      system = {
        searxng.enable = true;
        mullvad.enable = true;
        docker.enable = true;

        # I really need to get a server. The arr services are growing
        navidrome = {
          enable = true;
          musicFolder = "/mnt/big_bulk/Music";
        };
        jellyfin.enable = true;
        prowlarr.enable = true;
        sonarr.enable = true;
        radarr.enable = true;
        qbittorrent.enable = true;
      };

      user = {
        jellyfin-mpv-shim.enable = true;
        easyeffects = {
          enable = true;
          presets.output = {
            "DT-770 Pro (80 Ohm)" = import ./easyeffects_dt770.nix; # Desktop
            "SE215" = import ./easyeffects_se215.nix; # In-ears for VR
          };
          autoload.output = [
            {
              device = "alsa_output.usb-Focusrite_Scarlett_2i2_USB_Y81D0Z1157634E-00.HiFi__Line__sink";
              device-description = "Scarlett 2i2 3rd Gen Headphones / Line 1-2";
              device-profile = "Headphones / Line 1-2";
              preset-name = "DT-770 Pro (80 Ohm)";
            }
            {
              device = "wivrn.sink";
              device-description = "WiVRn";
              device-profile = "";
              preset-name = "SE215";
            }
          ];
        };

        gsr-replay = {
          enable = true;

          video = {
            codec = "av1_10bit";
            bitrate = 20000;
          };

          audio = {
            sources = [
              "app-inverse:mpd.PipeWire Output|app-inverse:LibreWolf|app-inverse:mpv" # Everything except mpd, zen, and mpv
              "app:mpd.PipeWire Output|app:LibreWolf|app:mpv" # mpd, zen, and mpv
              "default_input"
            ];
            bitrate = 320;
          };
        };
      };
    };
  };

  # /!\ DO NOT CHANGE /!\
  system.stateVersion = "25.11";
}
