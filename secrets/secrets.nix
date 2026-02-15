let
  # root nixos desktop
  nixos_desktop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAwA0Qn2WZa+mz79ehNsLBOj2uV+dTJOuoLduxsOk+bk";
in
{
  "github_ssh_mxapd.age".publicKeys = [ nixos_desktop ];
  "gitlab_ssh_lnu.age".publicKeys = [ nixos_desktop ];
  "gitea_ssh_ancient.age".publicKeys = [ nixos_desktop ];
  "gitea_ssh_swahnlabs.age".publicKeys = [ nixos_desktop ];
}
