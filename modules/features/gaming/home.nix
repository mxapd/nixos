# modules/features/gaming/home.nix
# Gaming configuration (home-manager)

{ config, pkgs, ... }:

{
  # Home-manager gaming configs can go here
  # Examples: Lutris configs, game-specific settings, MangoHud config

  # MangoHud configuration
  programs.mangohud = {
    enable = false;  # Set to true to enable by default
    # settings = {
    #   fps = true;
    #   frametime = true;
    #   gpu_temp = true;
    #   cpu_temp = true;
    # };
  };

  # Steam user settings (if needed)
  # programs.steam.enable = true;  # This would enable Steam in home-manager (different from system Steam)
}
