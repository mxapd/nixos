{ ... }: {
  flake.nixosModules.virtualbox = { ... }: {
    boot.kernelParams = [ "kvm.enable_virt_at_load=0" ];

    virtualisation.virtualbox.host.enable = true;
    virtualisation.virtualbox.host.enableExtensionPack = true;
    #virtualisation.virtualbox.guest.enable = true;
    #virtualisation.virtualbox.guest.dragAndDrop = true;

    users.extraGroups.vboxusers.members = [ "xam" ];
  };
}
