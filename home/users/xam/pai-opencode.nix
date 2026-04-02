# PAI-OpenCode Configuration for xam
# Add this to your ~/nixos/home/users/xam/xam.nix or import it

{ config, pkgs, ... }:

{
  # Add this to your imports in xam.nix:
  # imports = [
  #   ./pai-opencode.nix
  #   ... other imports ...
  # ];

  programs.pai-opencode = {
    enable = true;
    
    # Path to your git-managed PAI-OpenCode repo
    configSource = "${config.home.homeDirectory}/Projects/pai-opencode";
    
    # Map environment variable names to agenix secret names
    # The secret names refer to age.secrets definitions in secrets.nix
    secrets = {
      anthropic-api-key = "pai-anthropic-api-key";
      # Add more as needed:
      # openai-api-key = "pai-openai-api-key";
      # google-api-key = "pai-google-api-key";
    };
    
    # Non-sensitive environment variables (optional)
    environment = {
      # TZ = "Europe/Stockholm";
      # PAI_LOG_LEVEL = "debug";
    };
    
    # Extra packages available to PAI-OpenCode
    extraPackages = with pkgs; [
      ripgrep
      fd
      jq
    ];
  };
  
  # Optional: Additional shell aliases
  programs.zsh.shellAliases = {
    pvs = "pai-voice-server";
    pod = "pai-observability";
  };
}
