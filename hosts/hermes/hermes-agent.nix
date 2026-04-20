# hosts/hermes/hermes-agent.nix
{ config, pkgs, ... }:

{
  # Use default agenix - SSH host keys at /etc/ssh/ssh_host_*_key
  # No age.identityPaths needed - uses defaults from services.openssh.hostKeys

  age.secrets.hermes-env = {
    file = ../../secrets/hermes-env.age;
    owner = "hermes";
    group = "hermes";
  };

  # Install Python for manual hermes-agent setup
  environment.systemPackages = with pkgs; [
    python311
    python311Packages.pip
  ];

  services.hermes-agent = {
    enable = false;
    settings = {
      model.default = "opencode-go/kimi-k2.5";
      model.provider = "opencode-go";
    };
    addToSystemPackages = false;
  };

  systemd.services.hermes-agent = {
    serviceConfig.EnvironmentFile = config.age.secrets.hermes-env.path;
  };
}
