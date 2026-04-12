# modules/features/ssh/default.nix
# OpenSSH server configuration

{ config, pkgs, ... }:

{
  services.openssh = {
    enable = true;
    # Security hardening defaults
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };
}
