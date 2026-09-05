{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

with lib.hm.gvariant;

let
  gnomeExtensions = with pkgs.gnomeExtensions; [
    pop-shell # Tiling window manager extension
    burn-my-windows # Stylized window closing animations
    caffeine # Prevents the screen from locking or dimming
    vitals # System monitoring extension for CPU, RAM, etc.
    user-themes # Allows loading of user themes for GNOME Shell
  ];
in
{
  options.gnomeModule.enable = lib.mkEnableOption "Enable GNOME Module";

  config = lib.mkIf config.gnomeModule.enable {

    home.packages =
      with pkgs;
      [
        wmctrl
        gnome-tweaks
        wl-clipboard
        adwaita-icon-theme
        brightnessctl
      ]
      ++ gnomeExtensions;

    dconf.settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = map (extension: extension.extensionUuid) gnomeExtensions;
        favorite-apps = [ ];
      };

      "org/gnome/desktop/wm/preferences" = {
        button-layout = "close,minimize,maximize:appmenu";
        num-workspaces = 10;
        focus-mode = "sloppy";
      };

      "org/gnome/desktop/wm/keybindings" = {
        close = [ "<Super>q" ];
        toggle-maximized = [ "<Super>f" ];
        move-to-workspace-1 = [ "<Super><Shift>1" ];
        move-to-workspace-2 = [ "<Super><Shift>2" ];
        move-to-workspace-3 = [ "<Super><Shift>3" ];
        move-to-workspace-4 = [ "<Super><Shift>4" ];
        move-to-workspace-5 = [ "<Super><Shift>5" ];
        move-to-workspace-6 = [ "<Super><Shift>6" ];
        move-to-workspace-7 = [ "<Super><Shift>7" ];
        move-to-workspace-8 = [ "<Super><Shift>8" ];
        move-to-workspace-9 = [ "<Super><Shift>9" ];
        move-to-workspace-10 = [ "<Super><Shift>0" ];
        switch-to-workspace-1 = [ "<Super>1" ];
        switch-to-workspace-2 = [ "<Super>2" ];
        switch-to-workspace-3 = [ "<Super>3" ];
        switch-to-workspace-4 = [ "<Super>4" ];
        switch-to-workspace-5 = [ "<Super>5" ];
        switch-to-workspace-6 = [ "<Super>6" ];
        switch-to-workspace-7 = [ "<Super>7" ];
        switch-to-workspace-8 = [ "<Super>8" ];
        switch-to-workspace-9 = [ "<Super>9" ];
        switch-to-workspace-10 = [ "<Super>0" ];
        # F11 mirrors the Niri/Hyprland layout toggle (native GNOME OSD
        # shows the new source on switch).
        switch-input-source = [ "<Super>space" "F11" ];
        switch-input-source-backward = [ "<Super><Shift>space" ];
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        home = [ "<Super>e" ];
        screensaver = [ "<Super>Escape" ];
        control-center = [ "<Super>i" ];
      };

      # US English + Kannada (itrans phonetic); switch with <Super>space.
      "org/gnome/desktop/input-sources" = {
        sources = [ (mkTuple [ "xkb" "us" ]) (mkTuple [ "ibus" "m17n:kn:itrans" ]) ];
      };

      "org/gnome/shell/extensions/pop-shell" = {
        active-hint = true;
        hint-color-rgba = "rgba(255, 255, 255, 1.0)";
        fullscreen-launcher = false;
        show-title = true;
        smart-gaps = false;
        snap-to-grid = false;
        gap-inner = mkUint32 3;
        gap-outer = mkUint32 3;
        tile-by-default = true;
        tile-move-left-global = [ "<Super><Shift>h" ];
        tile-move-right-global = [ "<Super><Shift>l" ];
        tile-move-up-global = [ "<Super><Shift>k" ];
        tile-move-down-global = [ "<Super><Shift>j" ];
        toggle-floating = [ "<Super>v" ];
      };

      "org/gnome/shell/extensions/caffeine" = {
        enable-on-fullscreen = true;
        enable-on-media = true;
        allow-manual-toggle = false;
      };

      "org/gnome/shell/extensions/burn-my-windows" = {
        animation-time = 267;
        effect = 7; # TV Effect
      };
    };
  };
}
