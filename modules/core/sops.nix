{ inputs, pkgs, ... }:
{
  flake.nixosModules.sops = { config, pkgs, ... }: {

    imports = [ inputs.sops-nix.nixosModules.sops ];

    environment.systemPackages = with pkgs; [
      sops
    ];

    sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    
    environment.variables = {
      SOPS_AGE_KEY_FILE = "/home/xam/.age/sops_admin";
    };
  };
}
