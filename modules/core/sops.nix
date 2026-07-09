{ inputs, pkgs, ... }:
{
  flake.nixosModules.sops = { config, pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      sops
    ];     
      
    imports = [ inputs.sops-nix.nixosModules.sops ];
    # TODO export SOPS_AGE_KEY_FILE="$HOME/.age/sops_admin"
  };
}
