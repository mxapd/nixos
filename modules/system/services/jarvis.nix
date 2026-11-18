{ inputs, ... }:
{
  flake.nixosModules.jarvis = { ... }: {
    # The server; it imports nixosModules.jarvis too (the CLI, $JARVIS_URL).
    # Listens on 127.0.0.1:8485 only, so no firewall ports are opened.
    # Logs: journalctl -u jarvis
    imports = [ inputs.jarvis.nixosModules.jarvisServer ];

    # The calendar as an endpoint with no API and no units: it only shows up
    # in `jarvis ls`, so its app tab has a service to belong to.
    jarvis.endpoints.calendar = { };

    # Anything left out keeps its default (`jarvis ls --init-config` shows them all).
    home-manager.users.xam.xdg.configFile."jarvis/tui.toml".text = ''
      # cal-tui as the calendar service's tab: enter gives it the keys, ctrl+] takes them back.
      [apps]
      calendar = "cal-tui"
    '';
  };
}
