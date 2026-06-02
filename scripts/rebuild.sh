#!/usr/bin/env bash

echo "$(date '+%H:%M:%S'): Starting rebuild"

ret=$(pwd)
cd ~/nixos/ || { echo "Could not cd to ~/nixos"; exit 1; }

NIXOS_REBUILD_CMD="sudo -E nixos-rebuild switch --flake .#"

if [[ "${1:-}" == "--cool" || "${1:-}" == "-c" ]]; then
  NIXOS_REBUILD_CMD="systemd-run --scope -p CPUQuota=30% -- $NIXOS_REBUILD_CMD"
fi

if script -q -e -c "$NIXOS_REBUILD_CMD" /tmp/nixos-rebuild.log ; then
  if [[ -z "$(git status --porcelain)" ]]; then
    echo "$(date '+%H:%M:%S'): No changes to commit"
  else
    read -p "Commit and push? (y/n) " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
      printf "Commit message: "
      read -r msg

      if [ -z "$msg" ]; then
        msg="Update $(date '+%Y-%m-%d %H:%M:%S')"
      fi

      git add .
      git commit -m "$msg"
      echo "Committed: '$msg'"

      git push
      echo "$(date '+%H:%M:%S'): Pushed"
    else
      echo "Skipped commit"
    fi
  fi
else
  echo "$(date '+%H:%M:%S'): Rebuild failed. No changes committed."
fi

cd "$ret"
