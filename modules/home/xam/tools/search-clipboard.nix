{ ... }:

{
  flake.nixosModules.search-clipboard = { pkgs, ... }: {
    home-manager.users.xam.home.packages = [
      (pkgs.writeShellApplication {
        name = "search-clipboard";
        runtimeInputs = with pkgs; [ wl-clipboard libnotify coreutils jq ];
        text = ''
          #!/usr/bin/env bash

          set -euo pipefail

          CLIPBOARD=$(wl-paste --no-newline 2>/dev/null || true)

          if [[ -z "$CLIPBOARD" ]]; then
            notify-send "Clipboard is empty"
            exit 1
          fi

          QUERY=$(printf '%s' "$CLIPBOARD" | tr '\n' ' ' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | jq -sRr @uri)

          firefox --new-tab "https://duckduckgo.com/?q=$QUERY"
        '';
      })
    ];
  };
}
