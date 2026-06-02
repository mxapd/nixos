{ ... }:
{
  # Machines allowed to SSH into any host as xam.
  # Each line = contents of that machine's ~/.ssh/access.pub
  users.users.xam.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF7Yi6cfyNEXTeRo7KXRWdlL1hNd1hfaP1XEE3aMKEmK xam@desktop"   # desktop's access key
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGmaehyKKciN1watAjxAC+c0Y02WkZUdmAzyo3A1xuUT xam@laptop"    # laptop's access key
  ];
}
