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

    "/mnt/ssd" = {
      device = "/dev/disk/by-uuid/35f5796f-abf7-454e-935c-661606069483";
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
        monitors.DP-1 = {
          description = "Microstep G274QPF-QD CC2H253801114";
          resolution = "2560x1440";
          refreshRate = 165;
          cm = {
            primaries = "srgb";
            bitdepth = 10;
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

        settings.bind = [
          ", PRINT, exec, ${lib.getExe self'.packages.screenshot}"
          "CTRL, F2, exec, ${lib.getExe self'.packages.gsr-replay-save}"
        ];
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
      };

      virtualization.winboat.enable = true;

      vr.wivrn.enable = true;
    };

    services = {
      system = {
        jellyfin.enable = true;
        searxng.enable = true;
      };

      user = {
        mpd.enable = true;
        mpdris.enable = true;

        gsr-replay = {
          enable = true;

          video.codec = "av1_10bit";

          audio = {
            sources = [
              "app-inverse:mpd.PipeWire Output|app-inverse:Zen" # Everything except mpd and zen
              "app:mpd.PipeWire Output|app:Zen" # mpd and zen
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
