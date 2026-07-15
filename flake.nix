{
  description = "dendritic nixos flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    import-tree.url = "github:denful/import-tree";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    torzu.url = "git+http://gitea.yggdrasil.com/BMSwahn/Torzu";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.7.0";
    spellbook.url = "github:mxapd/spellbook";
  };


  outputs = inputs:
    let
      flakePartsOutputs = inputs.flake-parts.lib.mkFlake { inherit inputs; }
        (inputs.import-tree ./modules);
    in
    flakePartsOutputs // {
      formatter.x86_64-linux = inputs.nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
    };

}
