{ pkgs
, lib
, config
, ...
}:
{
  options.antigravity-cliModule.enable = lib.mkEnableOption "Enable antigravity-cli Module";

  config = lib.mkIf config.antigravity-cliModule.enable {

    home.packages = with pkgs; [
      antigravity-cli
    ];

  };
}
