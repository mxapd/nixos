{ inputs, pkgs, ... }:
{
  flake.nixosModules.sops = { config, pkgs, ... }: {

    imports = [ inputs.sops-nix.nixosModules.sops ];

    environment.systemPackages = with pkgs; [
      sops
    ];
    
    sops.age.keyFile = "/home/xam/.age/sops_admin";
    sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    sops.secrets."github_private_key" = {
      sopsFile = ../secrets/ssh-keys.yaml;
      path = "/home/xam/.ssh/github_mxapd";
      owner = "xam";
      mode = "0600";
    };
  
    sops.secrets."gitlab_lnu_private_key" = {
      sopsFile = ../secrets/ssh-keys.yaml;
      path = "/home/xam/.ssh/gitlab_lnu";
      owner = "xam";
      mode = "0600";
    };
  
    sops.secrets."gitea_private_key" = {
      sopsFile = ../secrets/ssh-keys.yaml;
      path = "/home/xam/.ssh/gitea";
      owner = "xam";
      mode = "0600";
    };
  };
}
