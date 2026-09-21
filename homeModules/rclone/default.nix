{ lib
, config
, ...
}:
{
  options.rcloneModule.enable = lib.mkEnableOption "Enable rclone Module";

  config = lib.mkIf config.rcloneModule.enable {

    programs.rclone = {
      enable = true;
    };

  };
}
