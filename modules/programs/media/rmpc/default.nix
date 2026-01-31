{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.modules.programs.media.rmpc;
in {
  options.modules.programs.media.rmpc = {
    enable = lib.mkEnableOption "rmpc";
  };

  config = lib.mkIf cfg.enable {
    hj = {
      packages = with pkgs; [rmpc cava];

      xdg.config.files = {
        "rmpc/config.ron".source = ./config.ron;
        "rmpc/themes/some.ron".text = let
          inherit (config.modules.desktops.common.style) accentColor;
        in ''
          #![enable(implicit_some)]
          #![enable(unwrap_newtypes)]
          #![enable(unwrap_variant_newtypes)]
          (
              default_album_art_path: None,
              show_song_table_header: true,
              draw_borders: true,
              format_tag_separator: " | ",
              browser_column_widths: [20, 38, 42],
              background_color: None,
              text_color: "#bfc6ce",
              header_background_color: None,
              modal_background_color: None,
              preview_label_style: (fg: "yellow"),
              preview_metadata_group_style: (fg: "yellow", modifiers: "Bold"),
              tab_bar: (
                  enabled: true,
                  active_style: (fg: "black", bg: "#${accentColor}", modifiers: "Bold"),
                  inactive_style: (),
              ),
              highlighted_item_style: (fg: "#${accentColor}", modifiers: "Bold"),
              current_item_style: (fg: "black", bg: "#${accentColor}", modifiers: "Bold"),
              borders_style: (fg: "#${accentColor}"),
              highlight_border_style: (fg: "#${accentColor}"),
              symbols: (song: "", dir: "", playlist: "", marker: "", ellipsis: ".."),
              progress_bar: (
                  symbols: [" ", " ", "", " ", " "],
                  track_style: (fg: "#1e2030"),
                  elapsed_style: (bg: "#${accentColor}"),
                  thumb_style: (fg: "#${accentColor}"),
              ),
              scrollbar: (
                  symbols: ["│", "█", "▲", "▼"],
                  track_style: (fg: "#bfc6ce"),
                  ends_style: (fg: "#bfc6ce"),
                  thumb_style: (fg: "#${accentColor}"),
              ),
              song_table_format: [
                  (
                      prop: (kind: Property(Artist),
                          default: (kind: Text("Unknown"))
                      ),
                      width: "25%",
                  ),
                  (
                      prop: (kind: Property(Title),
                          default: (kind: Text("Unknown"))
                      ),
                      width: "60%",
                  ),
                  (
                      prop: (kind: Property(Duration),
                          default: (kind: Text("-"))
                      ),
                      width: "15%",
                      alignment: Right,
                  ),
              ],
              header: (
                  rows: [
                      (
                          left: [
                              (kind: Text("["), style: (fg: "#${accentColor}", modifiers: "Bold")),
                              (kind: Property(Status(State)), style: (fg: "#${accentColor}", modifiers: "Bold")),
                              (kind: Text("]"), style: (fg: "#${accentColor}", modifiers: "Bold"))
                          ],
                          center: [
                              (kind: Property(Song(Title)), style: (modifiers: "Bold"),
                                  default: (kind: Text("No Song"), style: (modifiers: "Bold"))
                              )
                          ],
                          right: [
                              (kind: Property(Widget(ScanStatus)), style: (fg: "#${accentColor}")),
                              (kind: Property(Widget(Volume)), style: (fg: "#${accentColor}"))
                          ]
                      ),
                      (
                          left: [
                              (kind: Property(Status(Elapsed))),
                              (kind: Text(" / ")),
                              (kind: Property(Status(Duration))),
                              (kind: Text(" (")),
                              (kind: Property(Status(Bitrate))),
                              (kind: Text(" kbps)"))
                          ],
                          center: [
                              (kind: Property(Song(Artist)), style: (fg: "#${accentColor}", modifiers: "Bold"),
                                  default: (kind: Text("Unknown"), style: (fg: "#${accentColor}", modifiers: "Bold"))
                              ),
                              (kind: Text(" - ")),
                              (kind: Property(Song(Album)),
                                  default: (kind: Text("Unknown Album"))
                              )
                          ],
                          right: [
                              (
                                  kind: Property(Widget(States(
                                      active_style: (fg: "#${accentColor}", modifiers: "Bold"),
                                      separator_style: (fg: "#${accentColor}")))
                                  ),
                                  style: (fg: "#474758")
                              ),
                          ]
                      ),
                  ],
              ),
              browser_song_format: [
                  (
                      kind: Group([
                          (kind: Property(Track)),
                          (kind: Text(" ")),
                      ])
                  ),
                  (
                      kind: Group([
                          (kind: Property(Artist)),
                          (kind: Text(" - ")),
                          (kind: Property(Title)),
                      ]),
                      default: (kind: Property(Filename))
                  ),
              ],
              cava: (
                  bar_symbols: ['▁', '▂', '▃', '▄', '▅', '▆', '▇', '█'],
                  bar_width: 3,
                  bar_color: Single("#${accentColor}")
              ),
              layout: Split(
              direction: Vertical,
              panes: [
                  (
                      size: "4",
                      borders: "ALL",
                      pane: Pane(Header),
                  ),
                  (
                      size: "3",
                      pane: Pane(Tabs),
                  ),
                  (
                      size: "100%",
                      borders: "ALL",
                      pane: Pane(TabContent),
                  ),
              ],
          ),
          )
        '';
      };
    };

    # FIFO device for cava
    services.mpd.settings.audio_output = [
      {
        type = "fifo";
        name = "rmpc_fifo";
        path = "/tmp/rmpc.fifo";
        format = "44100:16:2";
      }
    ];
  };
}
