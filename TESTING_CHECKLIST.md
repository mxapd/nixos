# Dendritic Migration - Testing Checklist

## Post-Migration Verification

### Phase 1: System Health (Critical)
- [ ] System boots successfully
- [ ] SDDM display manager appears
- [ ] Can log in to Hyprland session
- [ ] No critical errors in `journalctl -b`

### Phase 2: Core Features (Previously Verified)
- [ ] Tailscale connected: `tailscale status`
- [ ] SSH service running: `systemctl status sshd`
- [ ] Audio working: `pactl info | grep "Server Name"`
- [ ] Fonts rendering: No tofu boxes in terminal

### Phase 3: Desktop Environment
- [ ] Hyprland loads (not falling back to another DE)
- [ ] Waybar appears at bottom of screen
- [ ] Mako notifications work: `notify-send "Test"`
- [ ] XDG portals functional (can open links in browser)
- [ ] Window management works (SUPER+Enter for kitty, etc.)

### Phase 4: User Features
- [ ] Zsh shell active: `echo $SHELL`
- [ ] Tmux sessionizer keybind: Ctrl+F
- [ ] Git config present: `git config user.name`
- [ ] Neovim launches: `nvim --version`
- [ ] Zoxide working: `z` command available
- [ ] Fzf working: Ctrl+R in shell

### Phase 5: Gaming & Hardware (Desktop Only)
- [ ] Steam launches: `steam &`
- [ ] NVIDIA drivers loaded: `nvidia-smi`
- [ ] Bluetooth service: `systemctl status bluetooth`

### Phase 6: Server Features (Ancient Server)
- [ ] Gitea accessible: http://ancient:3000
- [ ] Syncthing GUI: http://ancient:8384
- [ ] Samba shares mountable
- [ ] Jellyfin: http://ancient:8096
- [ ] Radicale: http://ancient:5232

### Phase 7: Architecture Verification
- [ ] Dendritic modules loading:
  ```bash
  nix eval .#nixosConfigurations.desktop.config.networking.hostName
  # Should output: "desktop"
  ```
- [ ] Feature isolation working:
  ```bash
  nix eval .#nixosConfigurations.desktop.config.services.pipewire.enable
  # Should output: true
  ```
- [ ] Ancient doesn't have desktop features:
  ```bash
  nix eval .#nixosConfigurations.ancient.config.programs.hyprland.enable 2>&1
  # Should error or be undefined
  ```

### Phase 8: Host-Specific Configs
- [ ] Desktop: All 16 features enabled
- [ ] Laptop: 13 features (no gaming/hardware)
- [ ] Ancient: 9 features (server only)
- [ ] Hermes: 7 features (minimal ARM)

## Quick Test Commands

```bash
# 1. Verify all hosts build
for host in desktop laptop ancient hermes; do
  echo "Testing $host..."
  nix build .#nixosConfigurations.$host 2>&1 | tail -1
done

# 2. Check feature modules exist
echo "=== Feature Modules ==="
nix eval .#nixosModules.features-desktop 2>/dev/null && echo "✓ desktop"
nix eval .#nixosModules.features-gaming 2>/dev/null && echo "✓ gaming"
nix eval .#nixosModules.features-server-gitea 2>/dev/null && echo "✓ gitea"

# 3. Check host-specific features
echo "=== Host Features ==="
nix eval .#nixosConfigurations.desktop.config.services.openssh.enable 2>/dev/null
echo "desktop has SSH: $?"

# 4. Runtime checks
echo "=== Runtime ==="
systemctl is-active tailscaled && echo "✓ tailscaled"
systemctl is-active sshd && echo "✓ sshd"
systemctl --user is-active pipewire && echo "✓ pipewire"
which zsh && echo "✓ zsh available"
which nvim && echo "✓ nvim available"
```

## Rollback Plan

If anything breaks:

```bash
# 1. Immediate rollback
sudo nixos-rebuild switch --rollback

# 2. Or boot previous generation
# At boot: Select "NixOS - Previous Generation"

# 3. Or switch back to main branch
git checkout main
sudo nixos-rebuild switch
```

## Success Criteria

✅ All checked items pass
✅ No unexpected errors in journalctl
✅ Comfortable daily usage possible
✅ Ready to merge to main
