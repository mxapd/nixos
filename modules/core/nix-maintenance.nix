{ ... }:
{
  flake.nixosModules.nix-maintenance = { ... }: {
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    nix.settings.auto-optimise-store = true;

    services.fstrim = {
      enable = true;
      interval = "weekly";
    };
  };
}
