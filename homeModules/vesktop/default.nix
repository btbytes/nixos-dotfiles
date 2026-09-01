{
  pkgs,
  lib,
  config,
  ...
}:

{
  options.vesktopModule.enable = lib.mkEnableOption "Enable Vesktop Module";

  config = lib.mkIf config.vesktopModule.enable {

    home.packages = [ pkgs.vesktop ];

    # ----------------------------------------------------------------
    # Wayland flags — passed via the desktop entry wrapper env var
    # that Vesktop reads. This file is never written to by the app.
    # ----------------------------------------------------------------
    xdg.configFile."vesktop/settings.json" = {
      force = true; # overwrite but don't symlink — copy instead
      text = builtins.toJSON {
        discordBranch = "stable";
        arRPC = true;
        minimizeToTray = false;
        openLinksWithElectron = false;
        additionalArguments = "--enable-features=UseOzonePlatform --ozone-platform=wayland";
      };
    };
  };
}
