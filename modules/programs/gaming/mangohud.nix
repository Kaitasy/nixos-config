{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.modules.programs.gaming.mangohud;
in {
  options.modules.programs.gaming.mangohud = {
    enable = lib.mkEnableOption "MangoHud";
  };

  config = lib.mkIf cfg.enable {
    hj = {
      packages = [pkgs.mangohud];

      xdg.config.files."MangoHud/MangoHud.conf".text = ''
        background_alpha=0.65
        background_color=0
        cpu_color=2E97CB
        cpu_load_change
        cpu_load_color=FFFFFF,FFAA7F,CC0000
        cpu_load_value=50,90
        cpu_stats
        font_file=${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono/JetBrainsMonoNerdFont-Bold.ttf
        font_size=24
        fps
        fps_metrics=avg,0.01
        frame_timing
        gpu_color=2E9762
        gpu_load_change
        gpu_load_color=FFFFFF,FFAA7F,CC0000
        gpu_load_value=50,90
        gpu_power
        gpu_stats
        no_display
        ram
        ram_color=C26693
        round_corners=8
        text_color=FFFFFF
        vram
        vram_color=AD64C1
      '';
    };
  };
}
