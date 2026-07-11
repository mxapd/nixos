{ ... }: {
  flake.nixosModules.audio = { pkgs, ... }: { 
    
    environment.systemPackages = with pkgs; [
      wiremix
    ];
    
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  }; 
}
