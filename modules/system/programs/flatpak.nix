{ ... }:
{
  flake.nixosModules.flatpak = { inputs, ... }: {
    imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

    services.flatpak = {
      enable = true;

      packages = [
        "com.adamcake.Bolt"
        "info.beyondallreason.bar"
      ];

      uninstallUnmanaged = true;

      update = {
        onActivation = true; # update declared apps on every `nixos-rebuild switch`
      };
    };
  };
}
