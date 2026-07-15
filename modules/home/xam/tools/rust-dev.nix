{ ... }:

{
  flake.nixosModules.rust-dev = { pkgs, ... }: {
    home-manager.users.xam = {
      home.packages = with pkgs; [
	rustc
	rustup
        gcc
        gnumake
        openssl
        pkg-config
        mold
      ];

      programs.zsh.initContent = ''
        export CARGO_HOME=''${CARGO_HOME:-$HOME/.cargo}
        export PATH="$CARGO_HOME/bin:$PATH"
        export RUSTFLAGS="-C link-arg=-fuse-ld=mold"
      '';
    };
  };
}
