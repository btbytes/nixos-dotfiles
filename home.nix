# Home Manager configuration for the "pradeep" user.
# Managed via the nixos-rebuild flake at ./flake.nix.
#
# Best practices followed here:
#   - Use dedicated `programs.*` / `services.*` modules instead of dropping
#     bare packages into `home.packages` where a module exists (so shell
#     hooks, completions and config are wired up automatically).
#   - Keep shared shell aliases in one place and reference from both bash/zsh.
#   - Prefer idiomatic CLI tools (eza, bat, zoxide) configured via modules.
{ config, pkgs, ... }:

let
  # Aliases shared by bash and zsh.
  shellAliases = {
    ll = "ls -la";
    rebuild = "sudo nixos-rebuild switch --flake ~/dotfiles#nixos";
  };
in
{
  home.username = "pradeep";
  home.homeDirectory = "/home/pradeep";
  home.stateVersion = "26.05";

  # Packages that have no dedicated home-manager module live here.
  home.packages = with pkgs; [
    bubblewrap
    c3c
    devenv
    dotnet-sdk_10
    dmd
    emacs-pgtk
    factor-lang
    fsharp
    ghostty
    go
    google-chrome
    gopls
    jdk25
    kitty
    nim
    nimble
    nixfmt
    odin
    opencode
    qtcreator
    quickshell
    rustup
    sbcl
    scala
    tmux
    tree
    unzip
    uv
    vscode
    zed-editor
  ];

  # ----------------------------------------------------------------------
  # Shells
  # ----------------------------------------------------------------------
  programs.bash = {
    enable = true;
    inherit shellAliases;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "sudo"
        "fzf"
        "docker"
        "direnv"
      ];
    };

    inherit shellAliases;
  };

  # ----------------------------------------------------------------------
  # CLI tools (dedicated modules provide shell integration)
  # ----------------------------------------------------------------------
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fd.enable = true;

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  programs.ripgrep.enable = true;

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  programs.htop.enable = true;

  programs.fastfetch.enable = true;

  programs.tmux = {
    enable = true;
    newSession = true;
    shortcut = "a";
  };

  programs.git = {
    enable = true;
    ignores = [
      ".DS_Store"
      "*.swp"
      "*~"
      "*.pyc"
      ".direnv/"
    ];

    settings = {
      user = {
        name = "Pradeep Gowda";
        email = "pradeep@btbytes.com";
      };

      alias = {
        ci = "commit";
        co = "checkout";
        s = "status";
        st = "status -sb";
        lg = "log --oneline --graph --decorate --all";
      };

      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core = {
        editor = "vim";
        whitespace = "trailing-whitespace,space-before-tab";
      };
    };
  };

  # ----------------------------------------------------------------------
  # Services
  # ----------------------------------------------------------------------
  services.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
    startWithUserSession = "graphical";
  };

  # Required so home-manager is managed by the NixOS module (see flake.nix).
  programs.home-manager.enable = true;
}
