#!/usr/bin/env bash
# Post-reboot verification script for dendritic NixOS
# Run this after rebooting to verify everything works

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PASS=0
FAIL=0

check() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ PASS${NC}"
        ((PASS++))
    else
        echo -e "${RED}❌ FAIL${NC}"
        ((FAIL++))
    fi
}

echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║       DENDRITIC NIXOS - POST-REBOOT VERIFICATION                 ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo ""

echo "📊 SYSTEM INFO"
echo "────────────────────────────────────────────────────────────────────"
echo "Hostname: $(hostname)"
echo "Kernel: $(uname -r)"
echo "Generation: $(sudo nix-env -p /nix/var/nix/profiles/system --list-generations 2>/dev/null | grep current | head -1 || echo 'unknown')"
echo ""

echo "🖥️  SYSTEM BOOT"
echo "────────────────────────────────────────────────────────────────────"
echo -n "Display manager (SDDM) running: "
systemctl is-active display-manager &>/dev/null && check || check

echo -n "Can get hostname from flake: "
nix eval .#nixosConfigurations.desktop.config.networking.hostName &>/dev/null && check || check

echo ""
echo "🔧 CORE SERVICES"
echo "────────────────────────────────────────────────────────────────────"
for service in tailscaled sshd NetworkManager; do
    echo -n "$service: "
    systemctl is-active $service &>/dev/null && check || check
done

echo ""
echo "🔊 AUDIO"
echo "────────────────────────────────────────────────────────────────────"
echo -n "PipeWire service: "
systemctl --user is-active pipewire &>/dev/null && check || check

echo -n "Audio server type: "
SERVER=$(pactl info 2>/dev/null | grep "Server Name" | cut -d: -f2 | xargs)
if [[ "$SERVER" == *"PipeWire"* ]]; then
    echo -e "${GREEN}✅ PASS${NC} ($SERVER)"
    ((PASS++))
else
    echo -e "${RED}❌ FAIL${NC} (expected PipeWire, got: $SERVER)"
    ((FAIL++))
fi

echo ""
echo "🐚 SHELL & TOOLS"
echo "────────────────────────────────────────────────────────────────────"
for tool in zsh nvim git tmux fzf; do
    echo -n "$tool available: "
    which $tool &>/dev/null && check || check
done

echo -n "Git config (user.name): "
if [ "$(git config user.name)" = "xam" ]; then
    echo -e "${GREEN}✅ PASS${NC}"
    ((PASS++))
else
    echo -e "${RED}❌ FAIL${NC}"
    ((FAIL++))
fi

echo -n "Zoxide installed: "
which zoxide &>/dev/null && check || check

echo ""
echo "🎮 DESKTOP ENVIRONMENT"
echo "────────────────────────────────────────────────────────────────────"
echo -n "Hyprland in PATH: "
which Hyprland &>/dev/null && check || check

echo -n "Waybar in PATH: "
which waybar &>/dev/null && check || check

echo -n "Mako in PATH: "
which mako &>/dev/null && check || check

echo -n "Kitty in PATH: "
which kitty &>/dev/null && check || check

echo ""
echo "🌳 DENDRITIC ARCHITECTURE"
echo "────────────────────────────────────────────────────────────────────"
echo -n "Desktop has SSH feature: "
nix eval .#nixosConfigurations.desktop.config.services.openssh.enable &>/dev/null && check || check

echo -n "Ancient has SSH feature: "
nix eval .#nixosConfigurations.ancient.config.services.openssh.enable &>/dev/null && check || check

echo -n "Ancient does NOT have Hyprland: "
if nix eval .#nixosConfigurations.ancient.config.programs.hyprland.enable 2>/dev/null | grep -q "true"; then
    echo -e "${RED}❌ FAIL${NC} (ancient has Hyprland!)"
    ((FAIL++))
else
    echo -e "${GREEN}✅ PASS${NC} (correctly disabled)"
    ((PASS++))
fi

echo ""
echo "════════════════════════════════════════════════════════════════════"
echo "                    RESULTS SUMMARY"
echo "════════════════════════════════════════════════════════════════════"
echo ""
echo -e "Passed: ${GREEN}$PASS${NC}"
echo -e "Failed: ${RED}$FAIL${NC}"
echo ""

if [ $FAIL -eq 0 ]; then
    echo -e "${GREEN}🎉 ALL TESTS PASSED! Dendritic migration is working correctly!${NC}"
    echo ""
    echo "You can now:"
    echo "  • Use your system normally"
    echo "  • Merge feat/dendritic-migration to main"
    echo "  • Add more features/hosts using the dendritic pattern"
    exit 0
else
    echo -e "${YELLOW}⚠️  SOME TESTS FAILED${NC}"
    echo ""
    echo "Options:"
    echo "  1. Check individual failed items above"
    echo "  2. Rollback: sudo nixos-rebuild switch --rollback"
    echo "  3. Rebuild current: sudo nixos-rebuild switch --flake .#desktop"
    exit 1
fi
