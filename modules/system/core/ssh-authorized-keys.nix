{ ... }:
{
  flake.nixosModules.ssh-authorized-keys = { ... }: {
    users.users.xam.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIYXIMoAZsZW5JwmIdNMjKBftTtHCkmYqjVRgfBSWfJH xam@hearth"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMw6u6BnzrwISM9w86T8ExyrsjhqG+N+GNWQGRaILd+n xam@sojourn"
    ];
  };
}
