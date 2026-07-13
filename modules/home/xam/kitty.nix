{ ... }:
{
  flake.nixosModules.kitty = { ... }: {
    home-manager.users.xam.programs = {
      kitty = {
        enable = true;
        extraConfig = ''
         confirm_os_window_close 0
        '';
      };
    };
  };
}
