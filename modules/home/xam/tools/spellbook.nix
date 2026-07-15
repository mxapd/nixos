{ inputs, ... }: {
  flake.nixosModules.spellbook = { pkgs, ... }: {
    imports = [ inputs.spellbook.nixosModules.default ];
    programs.spellbook.enable = true;
  };
}
