# modules/home-manager/default.nix
# Aggregates all home-manager modules for flake export

{ self, inputs, ... }:

{
  # Import the my.nix aggregator
  imports = [ ./my.nix ];
}