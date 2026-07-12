{ ... }:
{
  flake.nixosModules.ssh-authorized-keys = { ... }: {
    users.users.xam.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIYXIMoAZsZW5JwmIdNMjKBftTtHCkmYqjVRgfBSWfJH xam@hearth"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM0gQOFNq10llnG7EhMAnuoQ48rEOiJADfckn5kgN9A+ xam@laptop"
    ];
  };
}
