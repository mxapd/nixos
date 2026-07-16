{ ... }:

{
  flake.nixosModules.open-clipboard-link = { pkgs, ... }: {
    home-manager.users.xam.home.packages = [
      (pkgs.writeShellApplication {
        name = "open-clipboard-link";
        runtimeInputs = with pkgs; [ wl-clipboard libnotify coreutils gnugrep ];
        text = ''
          #!/usr/bin/env bash

          set -euo pipefail

          CLIPBOARD=$(wl-paste --no-newline 2>/dev/null || true)

          if [[ -z "$CLIPBOARD" ]]; then
            notify-send "Clipboard is empty"
            exit 1
          fi

          URL=$(printf '%s' "$CLIPBOARD" | grep -oE 'https?://[^[:space:]]+' | head -n 1)

          if [[ -z "$URL" ]]; then
            notify-send "No valid URL found in clipboard"
            exit 1
          fi

          firefox --new-tab "$URL"
        '';
      })
    ];
  };
}
