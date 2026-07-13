{ inputs, pkgs, ... }:
{
  flake.nixosModules.sops = { config, pkgs, ... }: {

    imports = [ inputs.sops-nix.nixosModules.sops ];

    environment.systemPackages = with pkgs; [
      age
      sops
    ];
    
    sops.age.keyFile = "/home/xam/.age/sops_admin";
    sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  };
}
