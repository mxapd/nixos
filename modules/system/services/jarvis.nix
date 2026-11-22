{ inputs, ... }:
{
  flake.nixosModules.jarvis = { ... }: {
    # The server; it imports nixosModules.jarvis too (the CLI, $JARVIS_URL).
    # Listens on 127.0.0.1:8485 only, so no firewall ports are opened.
    # Logs: journalctl -u jarvis
    imports = [ inputs.jarvis.nixosModules.jarvisServer ];

    # The MCP endpoint for AIs, loopback only (no firewall port):
    #   claude mcp add --transport http jarvis http://127.0.0.1:8486/mcp
    jarvis.server.ai.addresses = [ "127.0.0.1" ];

    # The calendar is not a Jarvis service for now: cal-tui main has no
    # `serve`/Jarvis support (that lives on cal-tui's jarvis-report branch).
    # The earlier setup is in `git stash list` and in commit f89e6d5.
  };
}
