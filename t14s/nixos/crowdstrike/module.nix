{  config, lib, pkgs, buildFHSUserEnv, libnl, openssl, zlib, ... }:

with lib;

let
  cfg = config;

  falcon = pkgs.callPackage ./falcon.nix {};

  falcon-env = pkgs.buildFHSUserEnv {
    name = "falcon-env";
    targetPkgs = pkgs: [ pkgs.libnl pkgs.openssl pkgs.zlib ];

    extraInstallCommands = ''
      ln -s ${falcon}/* $out/
    '';

    runScript = "bash";
  };
  
  startPreScript = pkgs.writeScript "init-falcon" ''
    #! ${pkgs.bash}/bin/sh
    # Enter Falcon FHS
    ${falcon-env}/bin/falcon-env
    # Crowdstrike expects to be installed under /opt/Crowdstrike
    mkdir -p /opt/CrowdStrike
    ln -sf ${falcon}/opt/CrowdStrike/* /opt/CrowdStrike
    # Set client id
    echo ${cfg.crowdstrike.cid}
    ${falcon}/opt/CrowdStrike/falconctl -s -f --cid='${cfg.crowdstrike.cid}'
    # ${falcon}/opt/CrowdStrike/falconctl -s -f --tags='${cfg.crowdstrike.email}'
    # ${falcon}/opt/CrowdStrike/falconctl -g --cid
  '';

in {
  options = {
      crowdstrike = {
        enable = mkEnableOption "Crowdstrike falcon sensor";
        email = mkOption {
          type = types.str;
          example = "john.doe@example.com";
          description = ''
            The email of the user.
          '';
        };
        cid = mkOption {
          type = types.str;
          description = ''
            The Crowdstrike customer ID.
          '';
        };
    };
  };
  
  config =
    mkIf cfg.crowdstrike.enable {
      systemd.services.falcon-sensor = {
        enable = true;
        description = "CrowdStrike Falcon Sensor";
        unitConfig.DefaultDependencies = false;
        after = [ "local-fs.target" ];
        conflicts = [ "shutdown.target" ];
        before = [ "sysinit.target" "shutdown.target" ];
        serviceConfig = {
          ExecStartPre = "${startPreScript}";
          ExecStart = "${falcon-env}/bin/falcon-env -c \"${falcon-env}/opt/CrowdStrike/falcond\"";
          Type = "forking";
          PIDFile = "/run/falcond.pid";
          Restart = "no";
          TimeoutStopSec = "60s";
          KillMode = "process";
        };
        wantedBy = [ "multi-user.target" ];
      };
  };
}
