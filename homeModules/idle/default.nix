{ config, lib, ... }:

let
  lock = "${config.programs.noctalia-shell.package}/bin/noctalia-shell ipc call lockScreen lock";
in
{
  options.idleModule.enable = lib.mkEnableOption "Lock screen after 5 minutes idle";

  config = lib.mkIf config.idleModule.enable {
    # Noctalia provides the lockscreen; swayidle watches for inactivity
    # and sleep. Absolute store path: user services can't rely on $PATH.
    services.swayidle = {
      enable = true;
      timeouts = [
        { timeout = 300; command = lock; }
      ];
      events = {
        before-sleep = lock;
      };
    };
  };
}
