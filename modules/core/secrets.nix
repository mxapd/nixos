{ inputs, ... }:
{
  flake.nixosModules.secrets = { config, ... }: {
      imports = [ inputs.sops-nix.nixosModules.sops ];
    };
}
