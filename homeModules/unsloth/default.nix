{ config, pkgs, lib, ... }:

let
  cfg = config.unslothModule;

  version = "0.1.913-beta";
  pname = "unsloth-desktop";

  unslothDesktop = pkgs.appimageTools.wrapType2 rec {
    inherit pname version;
    src = pkgs.fetchurl {
      url = "https://github.com/unslothai/unsloth/releases/download/v${version}/Unsloth-Desktop-Linux.AppImage";
      hash = "sha256-lL5KIaEO+Ap9wvz7VpoKE87h9FPQjMWRLntKvQrl7G4=";
    };
    extraPkgs = pkgs: [ pkgs.nghttp2 ];
    extraInstallCommands =
      let
        extracted = pkgs.appimageTools.extract { inherit pname version src; };
      in
      ''
        install -m 444 -D ${extracted}/usr/share/applications/Unsloth.desktop $out/share/applications/unsloth-desktop.desktop
        substituteInPlace $out/share/applications/unsloth-desktop.desktop \
          --replace-fail 'Exec=unsloth-studio %u' "Exec=$out/bin/unsloth-desktop"
        install -m 444 -D ${extracted}/usr/share/icons/hicolor/512x512/apps/unsloth-studio.png $out/share/icons/hicolor/512x512/apps/unsloth-studio.png
      '';
  };
in
{
  options.unslothModule.enable = lib.mkEnableOption "Unsloth AI Studio & Desktop environment";

  config = lib.mkIf cfg.enable {
    home.packages = [
      unslothDesktop
      (pkgs.writeShellScriptBin "unsloth-bootstrap" ''
                set -euo pipefail
                export LD_LIBRARY_PATH="/run/current-system/sw/share/nix-ld/lib:/run/opengl-driver/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
                export SSL_CERT_FILE="/etc/ssl/certs/ca-certificates.crt"

                echo "Installing / updating Unsloth Studio into ~/.unsloth/studio..."
                curl -fsSL https://unsloth.ai/install.sh | UNSLOTH_SKIP_AUTOSTART=1 sh

                echo "Validating dependencies..."
                "$HOME/.unsloth/studio/unsloth_studio/bin/unsloth" studio update

                # Install wrapper in ~/.local/bin/unsloth
                mkdir -p "$HOME/.local/bin"
                cat << 'WRAPPER' > "$HOME/.local/bin/unsloth"
        #!/usr/bin/env bash
        export LD_LIBRARY_PATH="/run/current-system/sw/share/nix-ld/lib:/run/opengl-driver/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
        export SSL_CERT_FILE="/etc/ssl/certs/ca-certificates.crt"
        exec "$HOME/.unsloth/studio/unsloth_studio/bin/unsloth" "$@"
        WRAPPER
                chmod +x "$HOME/.local/bin/unsloth"
                echo "Unsloth Studio & CLI ready. Try running: unsloth doctor"
      '')
    ];

    home.sessionVariables = {
      SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
    };

    home.sessionPath = [ "${config.home.homeDirectory}/.local/bin" ];
  };
}
