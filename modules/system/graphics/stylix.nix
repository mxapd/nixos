{ inputs, ... }:

{
  flake.nixosModules.stylix = {
    imports = [ inputs.stylix.nixosModules.stylix ];
    stylix.enable = true;
    stylix.targets.kmscon.enable = false;
  };
}
