# Simple grim/slurp wrapper
{
  writeShellApplication,
  grim,
  slurp,
  wl-clipboard,
  ...
}:
writeShellApplication {
  name = "screenshot";
  runtimeInputs = [grim slurp wl-clipboard];
  text = ''
    filename="$(date '+%y-%m-%d_%H%M%S').png"
    path="$HOME/Pictures/Screenshots/$filename"

    if [ ! -d "$HOME/Pictures/Screenshots" ]; then
      mkdir -p "$HOME/Pictures/Screenshots"
    fi

    sleep 0.1
    pidof slurp || (grim -t png -g "$(slurp -w 2)" "$path")

    # Copy screenshot to clipboard
    if [ -f "$path" ]; then
      wl-copy < "$path"
    fi
  '';
}
