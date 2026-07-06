#!/usr/bin/env bash
set -euo pipefail

dir="${HYPRSHOT_DIR:-$HOME/Pictures/Screenshots}"
mkdir -p "$dir"

tmp_name=".tmp-$(date +'%Y-%m-%d-%H%M%S').png"
tmp_path="$dir/$tmp_name"

hyprshot -m region -o "$dir" -f "$tmp_name"

name="$(printf '%s\n' "$(date +'%Y-%m-%d-%H%M%S')" | wofi --dmenu --prompt 'Save screenshot as')"

[ -z "${name:-}" ] && exit 0
[[ "$name" == *.png ]] || name="${name}.png"

final_path="$dir/$name"

if [ -e "$final_path" ]; then
  wofi --show dmenu --prompt "File exists: $name"
  exit 1
fi

mv -- "$tmp_path" "$final_path"
notify-send "Screenshot saved" "$final_path"
