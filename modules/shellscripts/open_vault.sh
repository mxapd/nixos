if [[ -z "$OBSIDIAN_VAULT" ]]; then
  echo "Error: OBSIDIAN_VAULT is not set. Please set the system variable."
fi

{ cd "$OBSIDIAN_VAULT"
echo "Now in directory: $(pwd)"} || {
  echo "Error: Unable to change directory to $OBSIDIAN_VAULT. Check if the folder exists."
}

