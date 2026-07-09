{ inputs, pkgs, ... }:
{
# TODO split this up somehow since like this every machine that gets the authorized keys also get the access key
  flake.nixosModules.ssh-access = { config, pkgs, ... }: {
    users.users.xam.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAwA0Qn2WZa+mz79ehNsLBOj2uV+dTJOuoLduxsOk+bk xam@desktop"
    ];

    sops.secrets."access" = {
      sopsFile = "../../secrets/ssh-keys.yaml";
      path = "/home/xam/.ssh/access";
      owner = "xam";
      mode = "0600";
    };
  };
}
