# modules/home-manager/shell.nix
# Shell configuration: zsh, tmux, kitty, zoxide
# This is the BASE module that enables home-manager

{ self, inputs, lib, ... }:

{
  flake.homeModules.shell = { config, pkgs, lib, ... }:
    {
      # User home config
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

        # User packages
        packages = with pkgs; [
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
        ];
      };

      # Programs
      programs.zoxide.enable = true;
      programs.zoxide.enableZshIntegration = true;
      programs.tmux.enable = true;
      programs.kitty.enable = true;
      programs.kitty.extraConfig = "confirm_os_window_close 0\n";
    };
}
