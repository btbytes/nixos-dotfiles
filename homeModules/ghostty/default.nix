{
  pkgs,
  lib,
  config,
  ...
}:

{
  options.ghosttyModule.enable = lib.mkEnableOption "Enable Ghostty Module";

  config = lib.mkIf config.ghosttyModule.enable {

    home.packages = [ pkgs.ghostty ];

    # ~/.config/ghostty/config
    xdg.configFile."ghostty/config".text = ''
      font-family = FiraCode Nerd Font
      font-family-bold = FiraCode Nerd Font
      font-family-italic = FiraCode Nerd Font
      font-family-bold-italic = FiraCode Nerd Font

      # Nerd Font symbol/icon fallback
      font-family = Symbols Nerd Font

      font-size = 12

      window-decoration = false

      theme = Monokai Pro
    '';
  };
}
