flake:
{ config, pkgs, lib, ... }:
let
  name = "gotta-scrape-em-all-service";
  cfg = config.services."${name}";
  inherit (flake.packages.${pkgs.stdenv.hostPlatform.system})
    gotta-scrape-em-all;
in with lib;
# builtins.trace ''hallo zzz: blar ${builtins.attrNames hallo.packages}''
{
  options = {
    services."${name}" = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = ''
          Start ${name}
        '';
      };
      user = mkOption {
        default = name;
        type = with types; uniq string;
        description = ''
          Name of the user.
        '';
      };
    };
  };
  config = mkIf cfg.enable {
    users.users."${cfg.user}" = {
      description = "${name} daemon user";
      isSystemUser = true;
      group = "${cfg.user}";
    };
    users.groups."${cfg.user}" = { };
    systemd.services."${name}" = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "Start ${name}.";
      serviceConfig = {
        Type = "simple";
        User = "${cfg.user}";
        ExecStart = "${gotta-scrape-em-all}/bin/gotta-scrape-em-all";
      };
    };
  };
}
