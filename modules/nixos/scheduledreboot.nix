{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.server.scheduledreboot;
in
{
  options.custom.server.scheduledreboot = {
    enable = lib.mkEnableOption "enable scheduled reboot everyday at specified time";
    time = lib.mkOption {
      type = lib.types.str;
      default = "04:00:00";     
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.timers."scheduledreboot" = {
      wantedBy = [ "timers.target" ];
        timerConfig = {
          #OnBootSec = "5m";
          #OnUnitActiveSec = "5m";
          # Alternatively, if you prefer to specify an exact timestamp
          # like one does in cron, you can use the `OnCalendar` option
          # to specify a calendar event expression.
          # Run every Monday at 10:00 AM in the Asia/Kolkata timezone.
          OnCalendar = cfg.time;
          Unit = "scheduledreboot.service";
        };
    };

    systemd.services."scheduledreboot" = {
      script = ''
        set -eu
        ${pkgs.coreutils}/bin/echo "Scheduled Reboot NOW!"
        "${pkgs.systemd}/bin/systemctl" --force reboot
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "root";
        RemainAfterExit = true; # Prevents the service from automatically starting on rebuild. See https://discourse.nixos.org/t/how-to-prevent-custom-systemd-service-from-restarting-on-nixos-rebuild-switch/43431
      };
    };
  };
}
