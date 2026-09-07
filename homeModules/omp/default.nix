{ config, pkgs, lib, ... }:

{
  options.ompModule.enable = lib.mkEnableOption "oh-my-pi (omp) coding agent, routed at local llama-server";

  config = lib.mkIf config.ompModule.enable {
    # nixpkgs has no omp package, so install via Bun (upstream's
    # recommended path) like the SGLang sidecar uses uv.
    home.packages = with pkgs; [
      (writeShellScriptBin "omp-bootstrap" ''
        set -euo pipefail
        bun install -g @oh-my-pi/pi-coding-agent
        echo "Verify provider discovery with: omp models aihole-llama"
        echo "Then run 'omp setup' and pick aihole-llama/qwen38-27b as default,"
        echo "or '/model' mid-session to assign it to the default role."
      '')
    ];

    # Bun global installs land in ~/.bun/bin; put it on PATH.
    home.sessionPath = [ "${config.home.homeDirectory}/.bun/bin" ];

    # Custom OpenAI-compatible provider for the local Qwen3.8-27B
    # llama-server (services.llama-cpp, :8090, alias qwen38-27b).
    # Only models.yml is managed — config.yml stays owned by omp
    # (`omp setup` writes the default-model picker result there).
    home.file.".omp/agent/models.yml".text = ''
      providers:
        aihole-llama:
          baseUrl: http://127.0.0.1:8090/v1
          api: openai-completions
          apiKey: dummy
          models:
            - id: qwen38-27b
              name: Qwen3.8-27B UD-Q6_K_M (local llama-server)
              contextWindow: 32768
              maxTokens: 16384
    '';
  };
}
