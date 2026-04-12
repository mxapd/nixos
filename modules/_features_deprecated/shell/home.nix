# modules/features/shell/home.nix
# Shell configuration (home-manager)

{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      # Nix aliases
      nd = "nix develop";
      ns = "nix shell";
      check = "nix flake check --impure";
    };

    initContent = ''
      # setting up and binding tmux sessionizer
      tmux_sessionizer_widget() {
        zle -I
        tmux-sessionizer
      }

      zle -N tmux_sessionizer_widget
      bindkey '^f' tmux_sessionizer_widget

      # loading ssh keys
      if [ -z "$SSH_AUTH_SOCK" ]; then
        eval "$(ssh-agent -s)" > /dev/null
        ssh-add ~/.ssh/lnu_ed25519 2>/dev/null
      fi

      # automatically start tmux when opening a shell if appropriate
      if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
        exec tmux
      fi

      PROMPT='[%1~] •%f '
      RPROMPT='$(git_prompt_info) %T'
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "wedisagree";
    };
  };

  # Tmux configuration
  programs.tmux = {
    enable = true;
    # Basic tmux settings - user can customize in their home config
  };

  # Zoxide (smart cd)
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # Fzf (fuzzy finder)
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
