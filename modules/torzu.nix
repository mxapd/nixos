{ pkgs, inputs, ... }:
{
  environment.systemPackages = [
    inputs.torzu.packages.${pkgs.system}.default
  ];
}
