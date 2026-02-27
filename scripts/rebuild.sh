#!/usr/bin/env bash

echo "$(date '+%H:%M:%S'): Starting rebuild"

ret=$(pwd)
cd ~/nixos/

  if script -q -e -c "sudo -E nixos-rebuild switch --flake .# --impure " /tmp/nixos-rebuild.log ; then
  read -p "Commit and push? (y/n) " -n 1 -r
  echo

  if [[ $REPLY =~ ^[Yy]$ ]]; then
    printf "Commit message: "
    read msg
  
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
else
  echo "$(date '+%H:%M:%S'): Rebuild failed. No changes committed."
fi

cd "$ret"
