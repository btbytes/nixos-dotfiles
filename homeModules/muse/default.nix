{ config, pkgs, lib, ... }:

{
  options.museModule.enable = lib.mkEnableOption "Meta Muse CLI coding agent";

  config = lib.mkIf config.museModule.enable {
    # nixpkgs has no Meta Muse package (its `muse` is a MIDI sequencer),
    # so install via the upstream installer, like the omp agent uses bun
    # and the SGLang sidecar uses uv. MUSE_NO_MODIFY_PATH=1 keeps the
    # installer out of the shell rc files — Home Manager owns $PATH via
    # home.sessionPath below.
    home.packages = with pkgs; [
      (writeShellScriptBin "muse-bootstrap" ''
        set -euo pipefail
        curl -fsSL https://dev.meta.ai/install.sh | \
          MUSE_NO_MODIFY_PATH=1 bash
        echo "muse installed to ~/.local/bin/muse (PATH via Home Manager)."
        echo "To get started, run: muse"
      '')
    ];

    # The installer drops the muse launcher in ~/.local/bin; put it on
    # PATH declaratively so the installer never edits ~/.bashrc / ~/.zshrc.
    home.sessionPath = [ "${config.home.homeDirectory}/.local/bin" ];
  };
}
