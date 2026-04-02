{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.pai-opencode;
  paiDir = "${config.home.homeDirectory}/.pai-opencode";
  
  toEnvVar = name: 
    let
      upper = lib.toUpper name;
      replaced = lib.replaceStrings ["-"] ["_"] upper;
    in replaced;
  
in {
  options.programs.pai-opencode = {
    enable = mkEnableOption "PAI-OpenCode - Personal AI Infrastructure";
    
    package = mkOption {
      type = types.package;
      description = "The PAI-OpenCode package";
      default = pkgs.callPackage ../../pkgs/pai-opencode {};
    };
    
    configSource = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "''${config.home.homeDirectory}/Projects/pai-opencode";
      description = "Path to your PAI-OpenCode git repository";
    };
    
    secrets = mkOption {
      type = types.attrsOf types.str;
      default = {};
      example = ''
        {
          anthropic-api-key = "pai-anthropic-api-key";
          openai-api-key = "pai-openai-api-key";
        }
      '';
      description = "Attribute set mapping env var names to agenix secret names";
    };
    
    environment = mkOption {
      type = types.attrsOf types.str;
      default = {};
      description = "Non-sensitive environment variables for ~/.pai-opencode/.env";
    };
    
    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Extra packages available to PAI-OpenCode";
    };
  };
  
  config = mkIf cfg.enable {
    home.packages = [ cfg.package ] ++ cfg.extraPackages ++ [
      pkgs.bun
      pkgs.git
    ];
    
    # Create base directories
    home.file = {
      "${paiDir}/.opencode/.gitkeep".text = "";
      "${paiDir}/.config/opencode/.gitkeep".text = "";
      "${paiDir}/.local/share/.gitkeep".text = "";
      "${paiDir}/.cache/.gitkeep".text = "";
    };
    
    # Generate .env file
    home.file."${paiDir}/.env" = {
      text = lib.concatLines (
        (lib.mapAttrsToList (name: secretName: 
          let
            secretPath = if config.age ? secrets && config.age.secrets ? ${secretName}
                        then config.age.secrets.${secretName}.path
                        else null;
          in
          if secretPath != null
          then ''${toEnvVar name}=$(cat "${secretPath}")''
          else "# Warning: Secret '${secretName}' not found"
        ) cfg.secrets)
        ++
        (lib.mapAttrsToList (name: value: ''${name}="${value}'') cfg.environment)
      );
    };
    
    # Setup symlinks activation script
    home.activation.paiOpencodeSetup = lib.hm.dag.entryAfter ["writeBoundary"] ''
      PAI_DIR="${paiDir}"
      mkdir -p "$PAI_DIR"/{.opencode,.config/opencode,.local/share,.cache}
      
      ${optionalString (cfg.configSource != null) ''
        if [ -d "${cfg.configSource}/.opencode" ]; then
          $DRY_RUN_CMD echo "Linking PAI-OpenCode from ${cfg.configSource}"
          
          for item in "${cfg.configSource}/.opencode"/*; do
            if [ -e "$item" ]; then
              basename_item=$(basename "$item")
              target="$PAI_DIR/.opencode/$basename_item"
              
              if [ -L "$target" ]; then
                current_link=$(readlink "$target" 2>/dev/null || true)
                if [ "$current_link" != "$item" ]; then
                  $DRY_RUN_CMD rm -f "$target"
                fi
              elif [ -e "$target" ] && [ ! -L "$target" ]; then
                $DRY_RUN_CMD mv "$target" "$target.backup.$(date +%Y%m%d%H%M%S)"
              fi
              
              if [ ! -e "$target" ]; then
                $DRY_RUN_CMD ln -s "$item" "$target"
              fi
            fi
          done
        fi
        
        # Link opencode.json
        if [ -f "${cfg.configSource}/opencode.json" ]; then
          target="$PAI_DIR/opencode.json"
          source="${cfg.configSource}/opencode.json"
          
          if [ -L "$target" ]; then
            current_link=$(readlink "$target" 2>/dev/null || true)
            if [ "$current_link" != "$source" ]; then
              $DRY_RUN_CMD rm -f "$target"
              $DRY_RUN_CMD ln -s "$source" "$target"
            fi
          elif [ -e "$target" ] && [ ! -L "$target" ]; then
            $DRY_RUN_CMD mv "$target" "$target.backup.$(date +%Y%m%d%H%M%S)"
            $DRY_RUN_CMD ln -s "$source" "$target"
          elif [ ! -e "$target" ]; then
            $DRY_RUN_CMD ln -s "$source" "$target"
          fi
        fi
      ''}
      
      chmod 600 "$PAI_DIR/.env" 2>/dev/null || true
      $DRY_RUN_CMD echo "PAI-OpenCode ready in $PAI_DIR"
    '';
    
    # Shell aliases
    programs.bash.shellAliases = mkIf config.programs.bash.enable {
      pai = "pai-opencode";
    };
    
    programs.zsh.shellAliases = mkIf config.programs.zsh.enable {
      pai = "pai-opencode";
    };
  };
}
