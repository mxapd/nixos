# modules/features/server/samba/home.nix
# Samba file sharing (home-manager)

{ config, pkgs, ... }:

{
  # Samba is entirely system-level
  # Users access shares through their file manager or mount command
  # No home-manager specific configuration needed
}
