# modules/features/shell/default.nix
# Shell configuration (NixOS system level)

{ config, pkgs, ... }:

{
  # Enable zsh system-wide
  programs.zsh.enable = true;

  # Make zsh the default shell for new users
  users.defaultUserShell = pkgs.zsh;

  # System-wide shell packages
  environment.systemPackages = with pkgs; [
    tmux
    zoxide
    fzf
  ];
}
