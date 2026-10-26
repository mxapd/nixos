{ ... }:
{
  flake.nixosModules.smartcard = { pkgs, ... }: {
    services.pcscd.enable = true;


    environment.systemPackages = with pkgs; [
       pcsc-tools
       opensc
       p11-kit
       openssl
       usbutils
     ];

  };
}
