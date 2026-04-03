{ config, pkgs, ... }:

{
  imports = [
    ./xam_stylix.nix
    ./waybar.nix
    ./hyprland.nix
    ./nixvim/nixvim.nix
    ./mako.nix
    ./git.nix
    ./zsh.nix
  ];

  home = {
    username = "xam";
    homeDirectory = "/home/xam";      
    stateVersion = "25.11";         
    
    sessionVariables = {
      OBSIDIAN_VAULT = "/home/xam/Documents/obsidian/";
      EDITOR = "nvim";
      BROWSER = "firefox";
      PATH = "$HOME/.local/bin:$PATH";
    };


    packages = with pkgs; [
      #teamspeak3
      ollama
      oh-my-zsh
      git-credential-manager
      zoxide
      wiremix
      bun
      calcurse
      (python3.withPackages (ppkgs: [
        ppkgs.matplotlib
        ppkgs.pytest
      ]))

      bubblewrap
      (writeShellScriptBin "opencode" ''
      exec ${pkgs.bubblewrap}/bin/bwrap \
        --ro-bind /nix/store /nix/store \
        --ro-bind /run/current-system /run/current-system \
        --ro-bind /etc /etc \
        --proc /proc \
        --dev-bind /dev /dev \
        --tmpfs /tmp \
        --tmpfs /home/xam \
        --bind ''${HOME}/Projects ''${HOME}/Projects \
        --ro-bind ''${HOME}/nixos ''${HOME}/nixos \
        --bind ''${HOME}/.config/opencode ''${HOME}/.config/opencode \
        --bind ''${HOME}/.local/state/opencode ''${HOME}/.local/state/opencode \
        --bind ''${HOME}/.local/share/opencode ''${HOME}/.local/share/opencode \
        --setenv HOME /home/xam \
        --unshare-ipc \
        --unshare-uts \
        --die-with-parent \
        ${pkgs.opencode}/bin/opencode "$@"
      '')

      (writeShellScriptBin "tmux-sessionizer" (builtins.readFile /home/xam/nixos/scripts/tmux-sessionizer))
      (writeShellScriptBin "tmux_toggle_notes" (builtins.readFile /home/xam/nixos/scripts/tmux_notes_toggle))
      #(writeShellScriptBin "nixos-warnings" (builtins.readFile ../../../scripts/nixos-warnings.sh))
      (writeShellScriptBin "rebuild" (builtins.readFile /home/xam/nixos/scripts/rebuild.sh))
    ];
  };

  programs = {
    zoxide.enable = true;
    zoxide.enableZshIntegration = true;                            	
                                                                 
    tmux = {                                                            
      enable = true;
    };

    kitty = {
      enable = true;
      extraConfig = ''
       confirm_os_window_close 0
      '';
    };
  };
}
