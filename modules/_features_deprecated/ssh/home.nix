# modules/features/ssh/home.nix
# Home-manager SSH configuration

{ config, pkgs, ... }:

{
  # User SSH config is typically in ~/.ssh/config (managed by home files)
  # Or could use programs.ssh.enable = true for basic client config
  programs.ssh.enable = true;
}
