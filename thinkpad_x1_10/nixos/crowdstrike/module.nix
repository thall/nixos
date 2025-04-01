{ config, lib, pkgs, ... }:

# Copied from: https://gist.github.com/spinus/be0ca03def0c856ada86b16d1727d09d

{
  options.custom.falcon =
    {
      enable = lib.mkOption {
        default = false;
        example = true;
        description = ''
          Whether to install Falcon Sensor from CrowdStrike.
        '';
      };
    };

  config =
    let
      falcon-sensor = pkgs.callPackage ./falcon-sensor.nix { };
      startPreScript = pkgs.writeScript "init-falcon" ''
        #! ${pkgs.bash}/bin/sh
        /run/current-system/sw/bin/mkdir -p /opt/CrowdStrike
        # /run/current-system/sw/bin/touch /var/log/falconctl.log
        ln -sf ${falcon-sensor}/opt/CrowdStrike/* /opt/CrowdStrike
        ${falcon-sensor}/bin/fs-bash -c "${falcon-sensor}/opt/CrowdStrike/falconctl -s -f --trace=debug --cid=EC5D4914B2A346E4BAE9CC66B4521718-D1"
        ${falcon-sensor}/bin/fs-bash -c "${falcon-sensor}/opt/CrowdStrike/falconctl -g --cid"
        ${falcon-sensor}/bin/fs-bash -c "${falcon-sensor}/opt/CrowdStrike/falconctl -s -f --trace=debug --tags=niclas_thall"
        ${falcon-sensor}/bin/fs-bash -c "${falcon-sensor}/opt/CrowdStrike/falconctl -g --tags"
      '';
    in
    lib.mkIf config.custom.falcon.enable
      {
        # environment.persistence."/persist".directories = [ "/opt/CrowdStrike/" ];

        systemd.services.falcon-sensor = {
          enable = true;
          description = "CrowdStrike Falcon Sensor";
          unitConfig.DefaultDependencies = false;
          after = [ "local-fs.target" ];
          conflicts = [ "shutdown.target" ];
          before = [ "sysinit.target" "shutdown.target" ];
          serviceConfig = {
            ExecStartPre = [ "${startPreScript}" ];
            ExecStart = "${falcon-sensor}/bin/fs-bash -c \"${falcon-sensor}/opt/CrowdStrike/falcond\"";
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
