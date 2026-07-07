let
  # --- Machine host keys ---------------------------------------------------
  # These are each host's /etc/ssh/ssh_host_ed25519_key.pub
  nixos_desktop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAwA0Qn2WZa+mz79ehNsLBOj2uV+dTJOuoLduxsOk+bk";
  laptop        = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM0gQOFNq10llnG7EhMAnuoQ48rEOiJADfckn5kgN9A+";
  hermes        = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO8Jgq6sCmPA7WcZttZQ5JOxV09JLsPfhfooOUQSsJHf";

  # Machines that need the GitHub/GitLab dev keys
  devHosts = [ nixos_desktop laptop ];
in
{
  # GitHub / GitLab dev keys: usable on desktop + laptop
  "github_ssh_mxapd.age".publicKeys = devHosts;
  "gitlab_ssh_lnu.age".publicKeys   = devHosts;

  # Hermes service env: only hermes needs it at runtime
  "hermes-env.age".publicKeys = [ hermes ];
}
