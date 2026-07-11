{ pkgs, ... }: 

{
  flake.nixosModules.tmux-notes = { pkgs, ... }: {
    environment.sessionVariables.OBSIDIAN_VAULT = "/home/xam/Documents/obsidian/";
    home-manager.users.xam.home.packages = [
    
      (pkgs.writeShellApplication {
	name = "tmux-notes";
	runtimeInputs = with pkgs; [ neovim tmux kitty];
	text = ''
#!/usr/bin/env bash

if ! tmux has-session -t notes 2>/dev/null; then
    tmux new-session -d -s notes -c "$OBSIDIAN_VAULT" "nvim"
fi

tmux attach -t notes
      '';
      })
    ];
  };
}
