#!/usr/bin/env bash

if ! tmux has-session -t notes 2>/dev/null; then
    tmux new-session -d -s notes -c "$OBSIDIAN_VAULT" "nvim"
fi

tmux attach -t notes
