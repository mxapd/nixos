{ config, pkgs, ... }:

{

  home.username = "xam";

  home.homeDirectory = "/home/xam";

  home.stateVersion = "23.05";

  home.packages = with pkgs; [
    oh-my-zsh
    git-credential-manager
    (python3.withPackages (ppkgs: [
      ppkgs.matplotlib
      ppkgs.pytest
    ]))
    zoxide
    fira-code
    fira-code-symbols
    font-awesome
    liberation_ttf
    mplus-outline-fonts.githubRelease
       noto-fonts
    noto-fonts-emoji
    proggyfonts
    ];

  fonts.fontconfig.enable = true;
  
  programs.zoxide.enable = true;
  programs.zoxide.enableZshIntegration = true;

  programs.tmux.enable = true;

  programs.git = {
    enable = true;
    userName = "xam";
    userEmail = "m.porseryd@gmail.com";
    extraConfig = {
      credential.helper = "manager";
      credential."https://gitlab.com".username = "mp224hv";
      credential.credentialStore = "cache";
    };
  };
  stylix.targets.hyprland.enable = true;
  stylix.targets.kde.enable = false;
  imports = [
    #./modules/neovim/neovim.nix
    ./modules/nixvim/nixvim.nix
    ./modules/hyprland/hyprland.nix
  ];

  home.sessionVariables = {
    OBSIDIAN_VAULT = "/home/xam/Documents/digitalbrain_clone";
  };

  programs.kitty = {
    enable = true;
    extraConfig = ''
       confirm_os_window_close 0
    '';
  };


  programs.zsh = {
    enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos/ --impure";
      oo = "source /home/xam/nixos/modules/shellscripts/open_vault.sh";
    };

    initExtra = ''
      eval "$(zoxide init zsh)"
      if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
      exec tmux
      exec tmux set -g mouse on
      fi
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [];
      theme = "wedisagree";
    };
  };
}
