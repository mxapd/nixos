{ self, inputs, ...}:
{
  flake.nixosModules.hyprland = { config, pkgs, ... }:
  {
    programs.hyprland.enable = true;

    environment.systemPackages =  with pkgs; [
      kitty # required for the default Hyprland config
    ];

    # hint Electron apps to use Wayland:
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
