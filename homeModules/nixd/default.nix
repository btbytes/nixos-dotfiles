{
  pkgs,
  lib,
  config,
  ...
}:

{
  options.nixdModule.enable = lib.mkEnableOption "Enable nixd Module";

  config = lib.mkIf config.nixdModule.enable {

    home.packages = with pkgs; [
      nixd
      nixpkgs-fmt
    ];

    xdg.configFile."nixd/config.json" = {
      force = true;
      text = builtins.toJSON {
        nixpkgs.expr = "import <nixpkgs> { }";
        formatting.command = [ "nixpkgs-fmt" ];
      };
    };
  };
}
