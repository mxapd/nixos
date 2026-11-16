{ ... }:
{
  flake.nixosModules.radicale = { ... }: {
    sops.secrets."radicale-users" = {
      sopsFile = ../../../secrets/radicale.yaml;
      path = "/run/secrets/radicale-users";
      owner = "radicale";
      group = "radicale";
      mode = "0600";
      };

    # Reachable over Tailscale only (http://ancient:5232); the LAN stays closed.
    networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 5232 ];

    services.radicale = {
      enable = true;
      settings = {
	server.hosts = [ "0.0.0.0:5232" ];
	auth = {
	  type = "htpasswd";
	  htpasswd_filename = "/run/secrets/radicale-users";
	  htpasswd_encryption = "bcrypt";
      };
    };
    };
  };
}
