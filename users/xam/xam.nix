{ inputs, pkgs, ... }:
{
  users.users.xam = {
    isNormalUser = true;
    # description = "xam";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  home-manager = {
    backupFileExtension = "backup";
    users.xam = {
    imports = [
	  ../../users/xam/home.nix
	];
    };

    sharedModules = [
      inputs.nixvim.homeModules.nixvim
    ];
  }
}
