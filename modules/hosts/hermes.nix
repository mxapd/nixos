# modules/hosts/hermes.nix
# Hermes ARM host configuration - complete system definition
# Combines: hardware-configuration.nix + configuration.nix + feature orchestration

{ self, inputs, ... }:

{
  flake.nixosConfigurations.hermes = inputs.nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    specialArgs = { inherit inputs self; };
    modules = [
      # Hardware configuration (from hosts/hermes/hardware-configuration.nix)
      ({ config, lib, pkgs, modulesPath, ... }: {
        imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

        boot.initrd.availableKernelModules = [ "usbhid" ];
        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ ];
        boot.extraModulePackages = [ ];

        fileSystems."/" = {
          device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
          fsType = "ext4";
        };

        swapDevices = [ ];
        networking.useDHCP = lib.mkDefault true;
        nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
      })

      # Bootloader and system config
      ({ config, pkgs, ... }: {
        boot.loader.grub.enable = false;
        boot.loader.generic-extlinux-compatible.enable = true;

        networking.hostName = "hermes";
        networking.extraHosts = ''
          100.64.0.17 gitea.yggdrasil.com
        '';

        age.identityPaths = [ "/home/nixos/.ssh/id_ed25519" ];

        # Different user account on hermes
        users.users.nixos = {
          isNormalUser = true;
          extraGroups = [ "wheel" ];
          initialPassword = "nixos";
          packages = with pkgs; [ git vim ];
        };

        environment.systemPackages = with pkgs; [ git vim ];
      })

      # Import hermes-agent module
      ../../modules/hermes-agent.nix

      # External flake modules
      inputs.hermes-agent.nixosModules.default
      inputs.agenix.nixosModules.default

      # Dendritic feature modules (minimal for ARM server)
      self.nixosModules.base
      self.nixosModules.users
      self.nixosModules.dev
      self.nixosModules.editor
    ];
  };
}
