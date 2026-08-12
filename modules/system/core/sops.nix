{ inputs, ... }:
{
  flake.nixosModules.sops = { pkgs, lib, ... }: {

    imports = [ inputs.sops-nix.nixosModules.sops ];

    environment.systemPackages = with pkgs; [
      ssh-to-age
      age
      sops
    ];

    sops.age.keyFile =  lib.mkIf (lib.pathExists /home/xam/.age/sops_admin) "/home/xam/.age/sops_admin";
    sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  };
}
