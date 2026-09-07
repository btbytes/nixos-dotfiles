# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 3;

  networking.hostName = "aihole"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Nix Experimetnal Settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Input method: IBus + m17n (Kannada itrans = phonetic transliteration).
  # Niri/Hyprland start ibus-daemon and toggle US/Kannada via F11
  # (Mod+Shift+Space kept as fallback; see homeModules/niri +
  # homeModules/hyprland); GNOME uses its native input sources instead
  # (see homeModules/gnome). toggle-keyboard-layout posts a Noctalia toast
  # with the new layout.
  i18n.inputMethod = {
    enable = true;
    type = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ m17n ];
    # Wayland frontend: Wayland-native apps (Zed, Chrome, Ghostty) take
    # input via text-input-v3/input-method-v2 (both exposed by Niri)
    # instead of the GTK/QT IM modules. This leaves GTK_IM_MODULE and
    # QT_IM_MODULE unset; XMODIFIERS stays for XWayland/XIM clients.
    ibus.waylandFrontend = true;
  };

  # Tells NixOS wrappers (Chrome, Electron apps) to prefer Wayland ozone,
  # which also adds Chrome's --enable-wayland-ime flag under Wayland.
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # GDM replaced by greetd + ReGreet below. The GNOME session itself stays
  # installed and selectable from the ReGreet session menu.
  services.displayManager.gdm.enable = false;

  # Enable the GNOME Desktop Environment (session stays available in ReGreet).
  services.desktopManager.gnome.enable = true;

  # Login screen: ReGreet (runs on cage via greetd) with a dark theme that
  # matches the Tokyo Night desktop. No background image: ReGreet 0.5.0 falls
  # back to GStreamer looping-video decode for static images (missing
  # glycin-loaders/bwrap in the wrapper, nixpkgs#557002), which pins a core
  # and freezes the login screen.
  services.displayManager.regreet = {
    enable = true;
    theme = { package = pkgs.adw-gtk3; name = "adw-gtk3-dark"; };
    iconTheme = { package = pkgs.papirus-icon-theme; name = "Papirus-Dark"; };
    cursorTheme = { package = pkgs.bibata-cursors; name = "Bibata-Modern-Classic"; };
    font = { package = pkgs.fira-sans; name = "Fira Sans"; size = 12; };
    extraCss = ''
      window.background {
        background-color: #292929;
      }
    '';
    settings = {
      appearance.greeting_msg = "Welcome back";
    };
  };

  # Niri Wayland compositor (selectable as a session in ReGreet).
  programs.niri.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # Use the WirePlumber session manager
    #wireplumber.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."pradeep" = {
    isNormalUser = true;
    description = "Pradeep Gowda";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      kdePackages.kate
      #  thunderbird
    ];
  };


  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    curl
    pciutils
    usbutils
    python3
    # Toggles US English <-> Kannada (itrans phonetic) IBus engine.
    # Bound to F11 (plus Mod+Shift+Space fallback) in Niri/Hyprland.
    (writeShellScriptBin "toggle-keyboard-layout" ''
      current=$(${pkgs.ibus}/bin/ibus engine 2>/dev/null)
      if [ "$current" = "m17n:kn:itrans" ]; then
        ${pkgs.ibus}/bin/ibus engine xkb:us::eng
        label="US English"
      else
        ${pkgs.ibus}/bin/ibus engine m17n:kn:itrans
        label="Kannada (phonetic)"
      fi
      if command -v noctalia-shell >/dev/null 2>&1; then
        noctalia-shell ipc call toast send "{\"title\":\"Keyboard\",\"body\":\"$label\",\"icon\":\"input-keyboard\",\"duration\":1500}" || true
      fi
    '')
    # Downloads the Qwen3.8-Flash-Next UD-IQ1_S shards (~72.5 GB) for
    # services.llama-cpp. Run with sudo (writes /var/lib/llama-cpp),
    # then `sudo systemctl start llama-cpp`. Resume-safe (aria2 -c).
    (writeShellScriptBin "qwen38-download" ''
      set -euo pipefail
      DEST="''${QWEN38_DIR:-/var/lib/llama-cpp}"
      BASE="https://huggingface.co/unsloth/Qwen3.8-Flash-Next-GGUF/resolve/main/UD-IQ1_S"
      mkdir -p "$DEST"
      for i in 1 2 3; do
        f="Qwen3.8-Flash-Next-UD-IQ1_S-0000$i-of-00003.gguf"
        ${pkgs.aria2}/bin/aria2c -x 8 -s 8 -c -d "$DEST" -o "$f" "$BASE/$f"
      done
      chmod 644 "$DEST"/Qwen3.8-Flash-Next-UD-IQ1_S-*.gguf
      echo "Done. Then: sudo systemctl stop ollama && sudo systemctl start llama-cpp"
    '')
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  programs.zsh.enable = true;

  fonts.packages = with pkgs; [
    fira-code
    fira-sans
    nerd-fonts.fira-code
    nerd-fonts.symbols-only
    # Kannada shaping (Noto Sans/Serif Kannada); without this fc-match
    # falls back to DejaVu/Unifont and conjuncts/ottaks render broken.
    noto-fonts
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PermitRootLogin = "no";
      # Keep password auth on for now so you don't lock yourself out
      # before key auth is verified. Set to false later for hardening.
      PasswordAuthentication = true;
    };
  };

  # Allow key-based login for pradeep (uses existing ~/.ssh/id_ed25519.pub).
  users.users."pradeep".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBSieB/wU+AVUhjnrtocMdY49SK1OBQGPE0LxeaGV4hX pradeep@nixos"
  ];

  # Tailscale VPN.
  services.tailscale = {
    enable = true;
    openFirewall = true; # opens UDP 41641, sets reverse-path to loose as needed
  };

  # ----------------------------------------------------------------------
  # GPU + local LLM serving (RTX 5090, the only VGA device in lspci).
  # ----------------------------------------------------------------------
  # NVIDIA driver: modesetting for Wayland (Niri/ReGreet), proprietary
  # module (Blackwell needs a recent driver; nixpkgs carries 595.x).
  # persistenced keeps /dev/nvidia* loaded for compute even when no
  # display client is touching the GPU (Ollama/SGLang need this).
  services.xserver.videoDrivers = [ "modesetting" "nvidia" ];

  hardware.graphics.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = false;
    nvidiaSettings = true;
    nvidiaPersistenced = true;
  };

  # Lets uv/pip wheels (SGLang sidecar, homeModules/sglang) resolve their
  # bundled dynamic libs on NixOS. Declarative packages don't need this.
  programs.nix-ld.enable = true;

  # Ollama: concurrent multi-model server with CUDA. VRAM is managed
  # automatically (keep-alive, LRU unload) — no manual VRAM partitioning.
  # Models pull declaratively at activation (~28 GB first time). Sized for
  # 32 GB VRAM with `llmfit --memory 32G recommend`; re-run post-rebuild
  # (GPU visible then) to refine and adjust loadModels.
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    host = "0.0.0.0";
    port = 11434;
    loadModels = [
      "qwen3:30b"
      "qwen2.5-coder:14b"
      "nomic-embed-text"
    ];
    environmentVariables = {
      # Keep models resident for concurrent serving (default unloads
      # after 5 min idle, which defeats concurrency).
      OLLAMA_KEEP_ALIVE = "1h";
    };
  };

  # Open WebUI: chat UI over the Ollama API (agents use the API directly).
  services.open-webui = {
    enable = true;
    host = "0.0.0.0";
    port = 8080;
    environment = {
      OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
    };
  };

  # ----------------------------------------------------------------------
  # llama-server for Qwen3.8-Flash-Next (unsloth UD-IQ1_S, ~72.5 GB).
  # The nixpkgs llama.cpp snapshot predates the qwen4exp architecture,
  # so track upstream v0.4.0 with a CUDA build. This is the only quant
  # fitting the box (62 GB RAM + 32 GB VRAM) and only with Ollama
  # unloaded — stop it first: `systemctl stop ollama`.
  # ----------------------------------------------------------------------
  services.llama-cpp = {
    enable = true;
    package = (pkgs.llama-cpp.override {
      cudaSupport = true;
      cudaPackages = pkgs.cudaPackages;
    }).overrideAttrs (old: {
      version = "0.4.0";
      src = pkgs.fetchFromGitHub {
        owner = "ggml-org";
        repo = "llama.cpp";
        tag = "v0.4.0";
        hash = "sha256-n540xQnFJOwpyRUXtHrv4/kHU3hguVJQUvanx2ZChR4=";
        leaveDotGit = true;
        postFetch = ''
          git -C "$out" rev-parse --short HEAD > $out/COMMIT
          find "$out" -name .git -print0 | xargs -0 rm -rf
        '';
      };
      npmDepsHash = "sha256-2Q7XhaLAArmviOLdQsNbYTfdyDE5pW9lR26cRHEVl9k=";
    });
    settings = {
      host = "0.0.0.0";
      port = 8090;
      # Sharded GGUF: point at shard 1, llama.cpp loads the rest from
      # the same directory. Fetch with `qwen38-download` (below) first;
      # the service stays skipped until the file exists.
      model = "/var/lib/llama-cpp/Qwen3.8-Flash-Next-UD-IQ1_S-00001-of-00003.gguf";
      ctx-size = 32768;
      temp = 0.6;
      top-p = 0.95;
      n-gpu-layers = 999;
    };
  };

  # Don't crash-loop before the model is downloaded.
  systemd.services.llama-cpp.unitConfig.ConditionPathExists =
    "/var/lib/llama-cpp/Qwen3.8-Flash-Next-UD-IQ1_S-00001-of-00003.gguf";

  # Serve the model API + chat UI on the tailnet only (aihole-1:
  # 100.101.214.127). Port 30000 belongs to the SGLang router sidecar,
  # which ships disabled (see homeModules/sglang).
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [
    11434 # ollama
    8080 # open-webui
    8090 # llama-server (Qwen3.8-Flash-Next)
    30000 # sglang router (sidecar, off by default)
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}
