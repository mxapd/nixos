{ config, pkgs, lib, ... }:

{
  services.postgresql = {
    enable = true;
    enableTCPIP = true;
    ensureDatabases = [ "mydatabase" ];
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  DBuser  auth-method
      local all       all     trust
      host    mydatabase    bruv    127.0.0.1/32    md5
    '';
  };
}
