{ ... }:
{
  flake.nixosModules.opencode = { pkgs, ... }: {
    home-manager.users.xam.home.packages = with pkgs; [
      opencode
      #bubblewrap
      #(writeShellScriptBin "opencode" ''
      #exec ${pkgs.bubblewrap}/bin/bwrap \
      #  --ro-bind /nix/store /nix/store \
      #  --ro-bind /run/current-system /run/current-system \
      #  --ro-bind /etc /etc \
      #  --proc /proc \
      #  --dev-bind /dev /dev \
      #  --tmpfs /tmp \
      #  --tmpfs /home/xam \
      #  --bind ''${HOME}/Projects ''${HOME}/Projects \
      #  --ro-bind ''${HOME}/nixos ''${HOME}/nixos \
      #  --bind ''${HOME}/.config/opencode ''${HOME}/.config/opencode \
      #  --bind ''${HOME}/.local/state/opencode ''${HOME}/.local/state/opencode \
      #  --bind ''${HOME}/.local/share/opencode ''${HOME}/.local/share/opencode \
      #  --setenv HOME /home/xam \
      #  --unshare-ipc \
      #  --unshare-uts \
      #  --die-with-parent \
      #  ${pkgs.opencode}/bin/opencode "$@"
      #'')
    ];
  };
}
