{ ... }:
{
  flake.nixosModules.kitty = { ... }: {
    home-manager.users.xam.programs = {
      kitty = {
        enable = true;
        
        remember_window_size = false;
        
        extraConfig = ''
          confirm_os_window_close 0
        '';
      };
    };
  };
}
