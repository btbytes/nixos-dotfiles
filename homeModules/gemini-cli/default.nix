{ pkgs
, lib
, config
, ...
}:
{
  options.gemini-cliModule.enable = lib.mkEnableOption "Enable gemini-cli Module";

  config = lib.mkIf config.gemini-cliModule.enable {

    home.packages = with pkgs; [
      gemini-cli
    ];

  };
}
