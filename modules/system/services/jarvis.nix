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

    # The calendar: `cal-tui serve` (a user service, below) answers the
    # Service API on loopback, so `jarvis ask calendar …` and the MCP tools
    # calendar__* reach it. Its tab in `jarvis ls` is still cal-tui itself.
    # No token: only this machine can reach 127.0.0.1.
    jarvis.endpoints.calendar = {
      url = "http://127.0.0.1:8487";
      # you: everything; ai: only reads. Add "add_event" "add_todo"
      # "complete_todo" to let AIs change the calendars.
      allow.ai = [ "today" "agenda" "next" "todos" "calendars" ];
    };

    home-manager.users.xam = {
      # Runs while xam is logged in; logs: journalctl --user -u cal-tui-serve
      services.cal-tui-serve = {
        enable = true;
        listen = "127.0.0.1:8487";
      };

      # Anything left out keeps its default (`jarvis ls --init-config` shows them all).
      xdg.configFile."jarvis/tui.toml".text = ''
        # cal-tui as the calendar service's tab: enter gives it the keys, ctrl+] takes them back.
        [apps]
        calendar = "cal-tui"
      '';
    };
  };
}
