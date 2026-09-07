{ config, pkgs, lib, ... }:

let
  cfg = config.sglangModule;
  venvPython = "${config.home.homeDirectory}/.local/share/sglang/.venv/bin/python";
  cudaLibPath = "/run/opengl-driver/lib";
in
{
  options.sglangModule = {
    enable = lib.mkEnableOption "SGLang multi-model sidecar (uv venv, per-model servers, router)";

    modelA = lib.mkOption {
      type = lib.types.str;
      default = "Qwen/Qwen3-8B-FP8";
      description = "HuggingFace ID served on port 8001.";
    };

    modelB = lib.mkOption {
      type = lib.types.str;
      default = "Qwen/Qwen2.5-Coder-1.5B-Instruct";
      description = "HuggingFace ID served on port 8002.";
    };

    memFractionA = lib.mkOption {
      type = lib.types.float;
      default = 0.30;
      description = "VRAM fraction for model A (fraction of free VRAM at startup).";
    };

    memFractionB = lib.mkOption {
      type = lib.types.float;
      default = 0.12;
      description = "VRAM fraction for model B (fraction of free VRAM at startup).";
    };
  };

  config = lib.mkIf cfg.enable {
    # uv builds the serving venv (nixpkgs has no sglang package).
    home.packages = with pkgs; [
      uv
      (writeShellScriptBin "sglang-bootstrap" ''
        set -euo pipefail
        VENV="$HOME/.local/share/sglang/.venv"
        # Last-known-good pins for RTX 5090 (Blackwell sm_120). Stock
        # sgl-kernel wheels historically lack sm_120 kernel images ("no
        # kernel image is available for execution on the device"), hence
        # torch from the cu128 index. Bump when SGLang publishes newer
        # Blackwell-verified releases, then re-run with --recreate.
        SGLANG_VERSION="''${SGLANG_VERSION:-0.5.8}"
        SGL_KERNEL_VERSION="''${SGL_KERNEL_VERSION:-0.3.21}"
        TORCH_INDEX="''${TORCH_INDEX:-https://download.pytorch.org/whl/cu128}"
        if [ "''${1:-}" = "--recreate" ]; then
          rm -rf "$VENV"
        fi
        if [ ! -x "$VENV/bin/python" ]; then
          uv venv --python 3.12 "$VENV"
          uv pip install --python "$VENV/bin/python" torch --index-url "$TORCH_INDEX"
          uv pip install --python "$VENV/bin/python" "sglang==$SGLANG_VERSION" --extra-index-url "$TORCH_INDEX"
          uv pip install --python "$VENV/bin/python" "sgl-kernel==$SGL_KERNEL_VERSION"
        fi
        "$VENV/bin/python" -c "import sglang, sgl_kernel; print('sglang venv OK')"
        echo "Next: smoke-test one server before enabling the services:"
        echo "  $VENV/bin/python -m sglang.launch_server --model-path Qwen/Qwen2.5-0.5B-Instruct --port 8010"
        echo "If CUDA reports no kernel image for sm_120, reinstall sgl-kernel"
        echo "from the sgl-project Blackwell wheel index, then re-run this script."
      '')
    ];

    # One model per server process; the router unifies them behind a
    # single OpenAI-compatible endpoint on :30000. Fractions are of free
    # VRAM at startup, so start these when Ollama isn't holding the GPU
    # (or shrink them) — the two stacks share 32 GB.
    systemd.user.services = {
      sglang-a = {
        Unit = {
          Description = "SGLang server A (${cfg.modelA})";
          After = [ "network-online.target" ];
          ConditionPathExists = [ "${config.home.homeDirectory}/.local/share/sglang/.venv/bin/python" ];
        };
        Service = {
          ExecStart = "${venvPython} -m sglang.launch_server --model-path ${cfg.modelA} --host 127.0.0.1 --port 8001 --mem-fraction-static ${toString cfg.memFractionA}";
          Environment = [
            "LD_LIBRARY_PATH=${cudaLibPath}"
            "HF_HUB_CACHE=%h/.cache/huggingface"
          ];
          Restart = "on-failure";
          RestartSec = 5;
        };
        Install.WantedBy = [ "default.target" ];
      };

      sglang-b = {
        Unit = {
          Description = "SGLang server B (${cfg.modelB})";
          After = [ "network-online.target" ];
          ConditionPathExists = [ "${config.home.homeDirectory}/.local/share/sglang/.venv/bin/python" ];
        };
        Service = {
          ExecStart = "${venvPython} -m sglang.launch_server --model-path ${cfg.modelB} --host 127.0.0.1 --port 8002 --mem-fraction-static ${toString cfg.memFractionB}";
          Environment = [
            "LD_LIBRARY_PATH=${cudaLibPath}"
            "HF_HUB_CACHE=%h/.cache/huggingface"
          ];
          Restart = "on-failure";
          RestartSec = 5;
        };
        Install.WantedBy = [ "default.target" ];
      };

      sglang-router = {
        Unit = {
          Description = "SGLang router (multi-model OpenAI endpoint :30000)";
          After = [ "sglang-a.service" "sglang-b.service" ];
          ConditionPathExists = [ "${config.home.homeDirectory}/.local/share/sglang/.venv/bin/python" ];
        };
        Service = {
          ExecStart = "${venvPython} -m sglang_router.launch_router --worker-urls http://127.0.0.1:8001 http://127.0.0.1:8002 --policy cache_aware --host 0.0.0.0 --port 30000";
          Environment = "LD_LIBRARY_PATH=${cudaLibPath}";
          Restart = "on-failure";
          RestartSec = 5;
        };
        Install.WantedBy = [ "default.target" ];
      };
    };
  };
}
