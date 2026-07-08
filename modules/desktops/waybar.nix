{ ... }:

{
  flake.nixosModules.waybar = { pkgs, ... }:
  {
    programs.waybar.enable = true;
  };
}
