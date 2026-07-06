#!/usr/bin/env bash
set -euo pipefail

dir="${HYPRSHOT_DIR:-$HOME/Pictures/Screenshots}"
mkdir -p "$dir"

timestamp="$(date +'%Y-%m-%d-%H%M%S')"
tmp_name=".tmp-${timestamp}.png"
tmp_path="$dir/$tmp_name"

# hyprshot exits with code 1 due to a bug in its checkRunning function
# (pkill hyprpicker fails when --freeze isn't used). Use --silent to
# suppress its built-in notification since we send our own below.
hyprshot -m region -o "$dir" -f "$tmp_name" --silent || true

# hyprshot saves the file in a background process — wait for it to finish
for _ in $(seq 1 50); do
    [ -f "$tmp_path" ] && break
    sleep 0.1
done

# If no file was created, the user cancelled the region selection
[ -f "$tmp_path" ] || exit 0

# Clean up temp file on any exit (cancellation, error, or success-after-rename)
trap 'rm -f "$tmp_path"' EXIT

name="$(printf '%s\n' "$timestamp" | wofi --dmenu --prompt 'Save screenshot as' --width 400 --exec-search --search "$timestamp" --lines 1 -s "$HOME/.config/wofi/screenshot.css")"

[ -z "${name:-}" ] && exit 0

[[ "$name" == *.png ]] || name="${name}.png"

final_path="$dir/$name"

if [ -e "$final_path" ]; then
    notify-send -u critical "Screenshot not saved" "File already exists: $name"
    exit 1
fi

mv -- "$tmp_path" "$final_path"
notify-send "Screenshot saved" "$final_path"
