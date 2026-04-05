# hosts/hermes/hermes-agent.nix
{ config, ... }:

{
  # Decrypt the agenix secret — readable by the hermes service user
  age.secrets.hermes-env = {
    file = ../../secrets/hermes-env.age;
    owner = "hermes";
    group = "hermes";
  };

  services.hermes-agent = {
    enable = true;
    settings.model.default = "opencode-go/kimi-k2.5";
    environmentFiles = [ config.sops.secrets."hermes-env".path ];
    addToSystemPackages = true;
  };
}
