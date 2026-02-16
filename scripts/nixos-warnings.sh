#!/usr/bin/env bash

log_file="/tmp/nixos-rebuild.log"

if [ ! -f "$log_file" ]; then
  echo "No build log"
  exit 0
fi

warnings=$(grep -i "warning" "$log_file" | sed 's/^[[:space:]]*//')

if [ -z "$warnings" ]; then
  echo "✓ No warnings"
  exit 0
fi

count=$(echo "$warnings" | wc -l)
echo "⚠ $count warnings"
