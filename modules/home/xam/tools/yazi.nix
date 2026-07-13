{ ... }:

{
  flake.nixosModules.hm-yazi = { pkgs, ... }: {
    home-manager.users.xam = {
      programs.yazi = {
        enable = true;
      };
    };
  };
}
