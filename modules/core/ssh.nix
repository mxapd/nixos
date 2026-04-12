# modules/core/ssh.nix
# OpenSSH server configuration

{ self, inputs, ... }:

{
  flake.nixosModules.ssh = { config, pkgs, ... }:
  {
    services.openssh = {
      enable = true;
      # Security hardening defaults
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };
}
