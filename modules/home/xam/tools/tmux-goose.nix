{ pkgs, ... }:

{
  flake.nixosModules.tmux-goose = { pkgs, ... }: {
    home-manager.users.xam.home.packages = [

      (pkgs.writeShellApplication {
        name = "tmux-goose";
        runtimeInputs = with pkgs; [ tmux goose-cli ];
        text = ''
          #!/usr/bin/env bash

          if ! tmux has-session -t goose 2>/dev/null; then
              tmux new-session -d -s goose -c "$HOME" "goose"
          fi

          tmux attach -t goose
        '';
      })
    ];
  };
}
