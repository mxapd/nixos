{ ... }:

# Fluxer (Discord alternative) — tailnet-only test instance on ancient.
#
#   URL:       https://100.64.0.14:8443   (tailnet IP; MagicDNS is off on headscale)
#   CA cert:   https://100.64.0.14:8443/ca.crt  (Caddy's internal root, friends must trust it)
#   Admin:     https://100.64.0.14:8443/admin
#
# Runs the official Docker Compose bundle (images are digest-pinned inside it).
# The bundle's own Caddy "edge" listens on 127.0.0.1:8090 only; the system Caddy
# terminates TLS with `tls internal`. LiveKit (voice) is bound to the tailnet IP
# because Docker-published ports bypass the NixOS firewall.
#
# Secrets live in secrets/fluxer.yaml (key fluxer_env, dotenv format). NEVER
# regenerate them after first start: Postgres/Meili/VAPID keys can't change.
#
# Upgrade: bump `bundleVersion` + hash (nix-prefetch-url --unpack <url>), rebuild.

{
  flake.nixosModules.fluxer = { pkgs, ... }:
    let
      tailnetIp = "100.64.0.14";
      publicPort = 8443;
      edgePort = 8090;
      origin = "https://${tailnetIp}:${toString publicPort}";
      stateDir = "/var/lib/fluxer";
      caddyRoot = "/var/lib/caddy/.local/share/caddy/pki/authorities/local/root.crt";

      bundleVersion = "2026.1124.80040";
      bundle = pkgs.fetchzip {
        url = "https://github.com/fluxerapp/fluxer/releases/download/fluxer-release%40${bundleVersion}/fluxer-compose-${bundleVersion}.tar.gz";
        hash = "sha256-mNO8H98YHzdQoWuU9/Q7SDvCqcFJQa6EbfdWf0+CgAU=";
        stripRoot = false;
      };

      # Non-secret settings. Secrets come from /run/secrets/fluxer-env.
      configEnv = pkgs.writeText "fluxer-config.env" ''
        FLUXER_SETTINGS_LOADED=true
        FLUXER_DOMAIN=${tailnetIp}
        FLUXER_PUBLIC_SCHEME=https
        FLUXER_PUBLIC_PORT=${toString publicPort}
        FLUXER_PUBLIC_ORIGIN=${origin}
        FLUXER_GATEWAY_ENDPOINT=wss://${tailnetIp}:${toString publicPort}/gateway
        FLUXER_EDGE_BIND=127.0.0.1:${toString edgePort}
        FLUXER_EMAIL_DELIVERY=off
        FLUXER_LIVEKIT_NODE_IP=${tailnetIp}
        FLUXER_LIVEKIT_USE_EXTERNAL_IP=false
        FLUXER_NODE_EXTRA_CA_CERTS=/etc/fluxer/ca/ca-bundle.crt
      '';

      # Keep voice ports off the LAN/WAN: bind them to the tailnet IP only.
      voiceOverride = pkgs.writeText "fluxer-tailnet.compose.yml" ''
        services:
          livekit:
            ports: !override
              - "${tailnetIp}:7881:7881"
              - "${tailnetIp}:7882:7882/udp"
      '';

      compose = "${pkgs.docker}/bin/docker compose"
        + " --project-name fluxer --project-directory ${stateDir}"
        + " -f ${stateDir}/docker-compose.yml"
        + " -f ${stateDir}/docker-compose.proxy.yml"
        + " -f ${voiceOverride}"
        + " --env-file ${configEnv} --env-file /run/secrets/fluxer-env";

      prepare = pkgs.writeShellScript "fluxer-prepare" ''
        set -eu
        # Wait for the tailnet IP so LiveKit's port bind doesn't fail at boot.
        for _ in $(seq 120); do
          ${pkgs.iproute2}/bin/ip -4 addr show | grep -q "inet ${tailnetIp}/" && break
          sleep 1
        done

        # Fresh copy of the bundle (compose mounts ./Caddyfile, ./certs, ./caddy.d, ./ca).
        cp -rT --no-preserve=mode,ownership ${bundle} ${stateDir}

        # Let api/worker trust Caddy's internal CA (for calls back to the public origin).
        cat /etc/ssl/certs/ca-certificates.crt > ${stateDir}/ca/ca-bundle.crt
        if [ -f ${caddyRoot} ]; then cat ${caddyRoot} >> ${stateDir}/ca/ca-bundle.crt; fi
      '';
    in
    {
      sops.secrets."fluxer-env" = {
        sopsFile = ../../../secrets/fluxer.yaml;
        key = "fluxer_env";
        mode = "0400";
        restartUnits = [ "fluxer.service" ];
      };

      systemd.services.fluxer = {
        description = "Fluxer chat (docker compose)";
        wantedBy = [ "multi-user.target" ];
        requires = [ "docker.service" ];
        wants = [ "network-online.target" "tailscaled.service" "caddy.service" ];
        after = [ "docker.service" "network-online.target" "tailscaled.service" "caddy.service" ];
        restartTriggers = [ bundle configEnv voiceOverride ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          StateDirectory = "fluxer";
          TimeoutStartSec = "20min"; # first start pulls ~20 images
          ExecStartPre = prepare;
          ExecStart = "${compose} up -d --remove-orphans --wait";
          ExecStop = "${compose} down";
        };
      };

      services.caddy.virtualHosts."https://${tailnetIp}:${toString publicPort}".extraConfig = ''
        tls internal

        # Friends download this and trust it to get rid of cert warnings.
        handle /ca.crt {
          root * /var/lib/caddy/.local/share/caddy/pki/authorities/local
          rewrite * /root.crt
          header Content-Type application/x-x509-ca-cert
          file_server
        }

        handle {
          reverse_proxy 127.0.0.1:${toString edgePort}
        }
      '';

      # Tailnet clients reach Caddy; Fluxer containers (docker bridges) reach it too.
      networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ publicPort ];
      networking.firewall.interfaces."br-+".allowedTCPPorts = [ publicPort ];
      networking.firewall.interfaces."docker0".allowedTCPPorts = [ publicPort ];
    };
}
