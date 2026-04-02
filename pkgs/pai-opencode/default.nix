{ lib
, stdenv
, bun
, git
, makeWrapper
, autoPatchelfHook
, pkg-config
, libsecret
, opencode-src
}:

stdenv.mkDerivation rec {
  pname = "pai-opencode";
  version = "2.0.0";
  
  src = opencode-src;
  
  nativeBuildInputs = [
    bun
    git
    makeWrapper
    autoPatchelfHook
    pkg-config
  ];
  
  buildInputs = [
    libsecret
    stdenv.cc.cc.lib
  ];
  
  BUN_INSTALL_CACHE_DIR = ".bun-cache";
  
  buildPhase = ''
    export HOME=$TMPDIR
    export BUN_INSTALL_CACHE_DIR=$TMPDIR/.bun-cache
    
    cat > bunfig.toml << 'EOF'
    [install]
    cache = true
    exact = true
    EOF
    
    echo "Installing dependencies..."
    bun install --frozen-lockfile --no-progress
    
    echo "Building OpenCode binary..."
    bun run ./packages/opencode/script/build.ts --single
  '';
  
  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/pai-opencode
    mkdir -p $out/libexec
    
    PLATFORM=$(uname -s | tr '[:upper:]' '[:lower:]')
    ARCH=$(uname -m | sed 's/x86_64/x64/' | sed 's/aarch64/arm64/')
    
    BUILT_BINARY="packages/opencode/dist/opencode-$PLATFORM-$ARCH/bin/opencode"
    
    if [ ! -f "$BUILT_BINARY" ]; then
      BUILT_BINARY=$(find packages/opencode/dist -type f \( -name "opencode" -o -name "opencode-*" \) 2>/dev/null | head -1)
    fi
    
    if [ -z "$BUILT_BINARY" ] || [ ! -f "$BUILT_BINARY" ]; then
      echo "ERROR: Could not find built opencode binary"
      exit 1
    fi
    
    cp "$BUILT_BINARY" $out/libexec/opencode-original
    chmod +x $out/libexec/opencode-original
    
    # Main wrapper
    cat > $out/bin/pai-opencode << 'WRAPPER'
    #!/usr/bin/env bash
    set -e
    
    export PAI_DIR="''${HOME}/.pai-opencode"
    export OPENCODE_CONFIG_DIR="''${PAI_DIR}/.opencode"
    export XDG_CONFIG_HOME="''${PAI_DIR}/.config"
    export XDG_DATA_HOME="''${PAI_DIR}/.local/share"
    export XDG_CACHE_HOME="''${PAI_DIR}/.cache"
    export XDG_STATE_HOME="''${PAI_DIR}/.local/state"
    
    mkdir -p "''${PAI_DIR}"/{.opencode,.config/opencode,.local/share,.cache}
    
    exec @LIBEXEC@/opencode-original "$@"
    WRAPPER
    
    substituteInPlace $out/bin/pai-opencode --replace "@LIBEXEC@" "$out/libexec"
    chmod +x $out/bin/pai-opencode
    
    # Voice server wrapper
    cat > $out/bin/pai-voice-server << 'VOICE_WRAPPER'
    #!/usr/bin/env bash
    export PAI_DIR="''${HOME}/.pai-opencode"
    export OPENCODE_CONFIG_DIR="''${PAI_DIR}/.opencode"
    
    VOICE_SERVER_DIR="''${PAI_DIR}/.opencode/voice-server"
    
    if [ ! -d "$VOICE_SERVER_DIR" ]; then
      echo "Error: Voice server directory not found at $VOICE_SERVER_DIR"
      exit 1
    fi
    
    cd "$VOICE_SERVER_DIR"
    exec bun run server.ts
    VOICE_WRAPPER
    
    chmod +x $out/bin/pai-voice-server
    
    # Observability wrapper
    cat > $out/bin/pai-observability << 'OBS_WRAPPER'
    #!/usr/bin/env bash
    export PAI_DIR="''${HOME}/.pai-opencode"
    export OPENCODE_CONFIG_DIR="''${PAI_DIR}/.opencode"
    
    OBS_DIR="''${PAI_DIR}/.opencode/observability-server"
    
    if [ ! -d "$OBS_DIR" ]; then
      echo "Error: Observability server directory not found at $OBS_DIR"
      exit 1
    fi
    
    cd "$OBS_DIR"
    exec bun run server.ts
    OBS_WRAPPER
    
    chmod +x $out/bin/pai-observability
  '';
  
  meta = with lib; {
    description = "PAI-OpenCode with model tier support";
    homepage = "https://github.com/Steffen025/pai-opencode";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
