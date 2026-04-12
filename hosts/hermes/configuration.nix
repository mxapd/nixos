# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./hermes-agent.nix
    ];

  # Agenix SSH identity for secrets
  age.identityPaths = [ 
    "/home/nixos/.ssh/id_ed25519"
  ];

  # ARM bootloader (different from x86_64)
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  # Host-specific networking
  networking.hostName = "hermes";
  networking.extraHosts = ''
    100.64.0.17 gitea.yggdrasil.com
  '';

  # Hermes uses different user account
  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "nixos";
    
    packages = with pkgs; [
      git
      vim
    ];
  };
}
