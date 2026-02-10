# Simple grim/slurp wrapper
{
  writeShellApplication,
  grim,
  slurp,
  wl-clipboard,
  jq,
  ...
}:
writeShellApplication {
  name = "screenshot";
  runtimeInputs = [grim slurp wl-clipboard jq];
  text = ''
    filename="$(date '+%y-%m-%d_%H%M%S').png"
    dir="$HOME/Pictures/Screenshots"
    path="$dir/$filename"

    if [ ! -d "$dir" ]; then
      mkdir -p "$dir"
    fi

    if [ "$1" == "monitor" ]; then
      monitor="$(hyprctl activeworkspace -j | jq --raw-output .monitor)"
      grim -t png -o "$monitor" "$path"
    elif [ "$1" == "region" ]; then
      pidof slurp || (grim -t png -g "$(slurp -w 2)" "$path")
    fi

    # Copy screenshot to clipboard
    if [ -f "$path" ]; then
      wl-copy < "$path"
    fi
  '';
}
