{ ... }: {
  flake.nixosModules.virtualbox = { ... }: {
    boot.kernelParams = [ "kvm.enable_virt_at_load=0" ];

    virtualisation.virtualbox = {
      host = { 
        enable = true;
        enableExtensionPack = true;
      };
   };
    
    users.extraGroups.vboxusers.members = [ "xam" ];

    nixpkgs.config.allowUnfree = true;
  };
}
