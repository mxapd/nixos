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
      oh-my-zsh
      git-credential-manager
      zoxide
      wiremix
      calcure
      (python3.withPackages (ppkgs: [
        ppkgs.matplotlib
        ppkgs.pytest
      ]))

      (writeShellScriptBin "tmux-sessionizer" (builtins.readFile /home/xam/nixos/scripts/tmux-sessionizer))
      (writeShellScriptBin "tmux_toggle_notes" (builtins.readFile /home/xam/nixos/scripts/tmux_notes_toggle))
      #(writeShellScriptBin "nixos-warnings" (builtins.readFile ../../../scripts/nixos-warnings.sh))
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
