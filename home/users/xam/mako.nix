{ pkgs, ... }:

{
  services.mako = {
    enable = true;
    package = pkgs.mako;
    settings = {
      default-timeout = 7000;
      border-radius = 5;
    };
  };
}
