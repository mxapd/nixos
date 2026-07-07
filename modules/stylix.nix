{ inputs, ... }:

{
  flake.nixosModules.stylix = {
    imports = [ inputs.stylix.nixosModules.stylix ];
    stylix.enable = true;
  };
}
