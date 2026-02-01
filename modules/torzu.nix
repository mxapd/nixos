{ pkgs, ... }:
let
  torzu-flake = builtins.getFlake "git+http://gitea.yggdrasil.com/BMSwahn/Torzu";
in
{
  environment.systemPackages = [
    torzu-flake.packages.${pkgs.system}.default
  ];
}
