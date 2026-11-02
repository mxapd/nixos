{ ... }:
{
  # 2DV703 Mobile & Wireless Security lab tooling.
  # Toggle in the host: lab = { enable = true; unifi.enable = true; wireless.enable = true; };
  flake.nixosModules.lab-exam = { config, lib, pkgs, ... }:
    let
      cfg = config.lab;
      nic = "enp0s31f6";

      lab-console = pkgs.writeShellApplication {
        name = "lab-console";
        runtimeInputs = with pkgs; [ picocom coreutils ];
        text = ''
          # Usage: lab-console [device] [baud]   (default: first ttyUSB/ttyACM, 9600)
          if [[ "''${1:-}" == "-h" || "''${1:-}" == "--help" ]]; then
            echo "usage: lab-console [/dev/ttyUSBx] [baud=9600]  (exit: C-a C-x)"
            exit 0
          fi
          dev="''${1:-}"
          baud="''${2:-9600}"
          if [[ -z "$dev" ]]; then
            for d in /dev/ttyUSB* /dev/ttyACM*; do
              [[ -e "$d" ]] && { dev="$d"; break; }
            done
          fi
          if [[ -z "$dev" ]]; then
            echo "No serial device found. Is the console cable plugged in? (check: dmesg | tail)" >&2
            exit 1
          fi
          mkdir -p "$HOME/lab-logs"
          log="$HOME/lab-logs/$(date +%Y%m%d-%H%M%S)-$(basename "$dev").log"
          echo "Connecting to $dev @ $baud, logging to $log  (exit: C-a C-x)"
          exec picocom -b "$baud" --logfile "$log" "$dev"
        '';
      };

      mkProfile = id: ipv4: {
        connection = {
          inherit id;
          type = "ethernet";
          interface-name = nic;
          autoconnect = "false";
        };
        inherit ipv4;
        ipv6.method = "disabled";
      };
    in
    {
      options.lab = {
        enable = lib.mkEnableOption "2DV703 lab tooling (serial console, network tools)";
        unifi.enable = lib.mkEnableOption "UniFi Network controller";
        wireless.enable = lib.mkEnableOption "wireless pentest tools";
        a456.enable = lib.mkEnableOption "A4-A6 tools (VPN clients, smartcard, YubiKey)";
      };

      config = lib.mkMerge [
        (lib.mkIf cfg.enable {
          users.users.xam.extraGroups = [ "dialout" ];

          environment.systemPackages = with pkgs; [
            lab-console
            picocom minicom screen tio putty
            inetutils nmap tcpdump dnsutils ethtool iw arp-scan iperf3 tftp-hpa
            freerdp
            poppler-utils pandoc usbutils pciutils
            woeusb-ng
          ];

          networking.networkmanager.ensureProfiles.profiles = {
            lab-dhcp = mkProfile "lab-dhcp" { method = "auto"; };
            lab-mgmt = mkProfile "lab-mgmt" {
              method = "manual";
              address1 = "10.0.99.50/24,10.0.99.1";
              dns = "8.8.8.8;";
            };
            lab-trusted-static = mkProfile "lab-trusted-static" {
              method = "manual";
              address1 = "10.0.10.250/24,10.0.10.1";
              dns = "8.8.8.8;";
            };
            lab-pfsense-default = mkProfile "lab-pfsense-default" { method = "auto"; };
          };

          # syslog, tftp, ntp for lab testing
          networking.firewall.allowedUDPPorts = [ 514 69 123 ];
        })

        (lib.mkIf (cfg.enable && cfg.unifi.enable) {
          services.unifi = {
            enable = true;
            openFirewall = true;
            unifiPackage = pkgs.unifi;
            # prebuilt binary; default `mongodb` compiles from source for hours
            mongodbPackage = pkgs.mongodb-ce;
          };
        })

        (lib.mkIf (cfg.enable && cfg.wireless.enable) {
          environment.systemPackages = with pkgs; [
            aircrack-ng hashcat hcxtools hcxdumptool macchanger mdk4 bettercap kismet
          ];
        })

        (lib.mkIf (cfg.enable && cfg.a456.enable) {
          # A4 VPN clients (+ NetworkManager GUI plugins)
          networking.networkmanager.plugins = with pkgs; [
            networkmanager-openvpn
            networkmanager-l2tp
            networkmanager-strongswan
            networkmanager-openconnect
          ];

          # A6 smartcard + YubiKey
          services.pcscd.enable = true;
          services.udev.packages = with pkgs; [ yubikey-personalization libfido2 ];

          environment.systemPackages = with pkgs; [
            wireguard-tools openvpn strongswan openconnect
            pcsc-tools opensc p11-kit
            yubikey-manager yubioath-flutter yubikey-personalization libfido2
          ];
        })
      ];
    };
}
