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
    dir="$HOME/Pictures/Screenshots"
    path="$dir/$filename"

    if [ ! -d "$dir" ]; then
      mkdir -p "$dir"
    fi

    pidof slurp || (grim -t png -g "$(slurp -w 2)" "$path")

    # Copy screenshot to clipboard
    if [ -f "$path" ]; then
      wl-copy < "$path"
    fi
  '';
}
