# modules/hosts/hermes/hermes.nix
# Hermes ARM host configuration
# Imports: hardware-configuration.nix + system configuration

{ self, inputs, ... }:

{
  flake.nixosConfigurations.hermes = inputs.nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    specialArgs = { inherit inputs self; };
    modules = [
      # Hardware configuration (imported as a module to get modulesPath)
      ({ modulesPath, ... }: {
        imports = [ 
          (modulesPath + "/installer/scan/not-detected.nix")
          ./hardware.nix 
        ];
      })

      # Bootloader and basic system config
      ({ config, pkgs, ... }: {
        boot.loader.grub.enable = false;
        boot.loader.generic-extlinux-compatible.enable = true;

        networking.hostName = "hermes";
        networking.extraHosts = ''
          100.64.0.17 gitea.yggdrasil.com
        '';

        # Different user account on hermes
        users.users.nixos = {
          isNormalUser = true;
          extraGroups = [ "wheel" ];
          # SECURITY WARNING: Change this password after first login!
          # Or remove this line and use agenix to set a proper password
          initialPassword = "nixos";
          packages = with pkgs; [ git vim ];
        };

        environment.systemPackages = with pkgs; [ git vim ];
      })

      # External flake modules (must be before any age.* usage)
      inputs.hermes-agent.nixosModules.default
      inputs.agenix.nixosModules.default

      # Import hermes-agent configuration (uses age.* options)
      ../../modules/_legacy/hermes-agent.nix

      # Config that uses age options (must be after agenix module)
      ({ config, ... }: {
        age.identityPaths = [ "/home/nixos/.ssh/id_ed25519" ];
      })

      # Dendritic feature modules (minimal for ARM server)
      self.nixosModules.base
      self.nixosModules.users
      self.nixosModules.dev
      self.nixosModules.editor
    ];
  };
}
