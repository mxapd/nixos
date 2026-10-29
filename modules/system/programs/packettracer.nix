{ ... }:
{
  flake.nixosModules.packettracer = { pkgs, lib, ... }:
  let
    debName = "CiscoPacketTracer_901_Ubuntu_64bit.deb";

    deb = builtins.path {
      path = ../../../files + "/${debName}";
      name = debName;
      recursive = false;
      sha256 = "sha256-NoPdh+d5iFNyrpo1wabllNEvST5knnxpdAhynBRZR5s=";
    };

    packetTracer = pkgs.cisco-packet-tracer_9;
  in
  {
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [ "cisco-packet-tracer" ];

    # Referencing it forces it into the store during evaluation,
    # before the package build looks for it.
    system.extraDependencies = [ deb ];

    programs.firejail = {
      enable = true;
      wrappedBinaries.packettracer9 = {
        executable = lib.getExe packetTracer;
        desktop = "${packetTracer}/share/applications/cisco-packet-tracer-9.desktop";
        extraArgs = [
          "--net=none"
          "--noprofile"
          # "--env=QT_STYLE_OVERRIDE="
        ];
      };
    };
  };
}
