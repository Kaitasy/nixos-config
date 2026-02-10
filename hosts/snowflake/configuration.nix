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
    "/mnt/bulk" = {
      device = "/dev/disk/by-uuid/a3958db6-8197-4622-b50f-5cdba2cc14bc";
      options = ["nofail"];
    };

    "/mnt/bulk2" = {
      device = "/dev/disk/by-uuid/e025414b-c53a-409c-a652-5b12cbed363c";
      options = ["nofail"];
    };
  };

  modules = {
    core = {
      user.username = "kaitasy";

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
        wallpaper = ../../wallpapers/__shian_synthesizer_v_drawn_by_mizhou_mzhu112646__079652ea128cecfe2ab3a0aee967f0eb.jpg;
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
          HDMI-A-1 = {
            description = "Samsung Electric Company U28E590 HTPJ708954";
            resolution = "2560x1440";
            x = -2560;
            refreshRate = 60;
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
        anyrun.plugins.enableNixRun = true;
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
    };

    programs = {
      development = {
        neovim.enable = true;
        git.enable = true;
      };

      social.discord.enable = true;

      gaming = {
        steam.enable = true;
        bs-manager.enable = true;
        trucky.enable = true;
        mangohud.enable = true;
        prismlauncher.enable = true;
        gamescope.enable = true;
        gamemode.enable = true;
        truckersmp-cli.enable = true;
      };

      media = {
        mpv.enable = true;
        rmpc.enable = true;
      };

      utility = {
        kitty.enable = true;
        playerctl.enable = true;
        pwvucontrol.enable = true;
        btop.enable = true;
        superfile.enable = true;
      };

      web = {
        zen.enable = true;
        qbittorrent.enable = true;
      };

      virtualization.winboat.enable = true;

      vr.wivrn.enable = true;

      flatpak = {
        enable = true;

        gaming = {
          hytale = true;
          sober = true;
        };

        creativity.kdenlive = true;

        utility = {
          bottles = true;
          gradia = true;
        };
      };
    };

    services = {
      system = {
        jellyfin.enable = true;
        searxng.enable = true;
        mullvad.enable = true;
      };

      user = {
        mpd.enable = true;
        mpdris.enable = true;
        jellyfin-mpv-shim.enable = true;
        easyeffects = {
          enable = true;
          presets.output = {
            "DT-770 Pro (80 Ohm)" = import ./easyeffects_dt770.nix;
          };
          autoload.output = [
            {
              device = "alsa_output.usb-Focusrite_Scarlett_2i2_USB_Y81D0Z1157634E-00.HiFi__Line__sink";
              device-description = "Scarlett 2i2 3rd Gen Headphones / Line 1-2";
              device-profile = "Headphones / Line 1-2";
              preset-name = "DT-770 Pro (80 Ohm)";
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
              "app-inverse:mpd.PipeWire Output|app-inverse:Zen|app-inverse:mpv" # Everything except mpd, zen, and mpv
              "app:mpd.PipeWire Output|app:Zen|app:mpv" # mpd, zen, and mpv
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
