{ pkgs
, lib
, config
, ...
}:

{
  options.llmfitModule.enable = lib.mkEnableOption "Enable llmfit Module";

  config = lib.mkIf config.llmfitModule.enable {

    home.packages = with pkgs; [
      llmfit
    ];

  };
}
